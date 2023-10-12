// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

// Project imports:

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore({
    required ApiService apiService,
    required LocationsStore locationsStore,
    required WireguardDart wireguardService,
    required AnalyticsStore analyticsStore,
    required SubscriptionStore subscriptionStore,
    required LocalDBService localDBService,
    required FlavorConfig env,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _analyticsStore = analyticsStore,
        _subscriptionStore = subscriptionStore,
        _localDBService = localDBService,
        _env = env {
    _connectionStatus = ConnectionStatus.disconnected;
    _connectingLocationCode = '';
    generateKey();
    _vpnConfigConsent = _localDBService.getVpnConsentApproval() ?? false;
    _resetConnection = _localDBService.getResetConnection();
    if (_vpnConfigConsent ?? false) {
      setupTunnel();
    }
  }

  final ApiService _apiService;
  final LocationsStore _locationsStore;
  final WireguardDart _wireguardService;
  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final FlavorConfig _env;
  final _securedStorage = SecureStorageService.instance;
  final LocalDBService _localDBService;
  final random = Random();

  Timer? _timer;

  CancelableOperation<VpnConnection>? _cancelableOperation;

  @readonly
  bool _resetConnection = true;

  @readonly
  bool? _vpnConfigConsent;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  VpnConfig? _vpnConfig;

  @readonly
  String _privateKey = '';

  @readonly
  String _publicKey = '';

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  bool get isConnected => _connectionStatus == ConnectionStatus.connected;
  @computed
  bool get isLoading =>
      _connectionStatus == ConnectionStatus.disconnecting ||
      _connectionStatus == ConnectionStatus.connecting;
  @readonly
  String? _connectingLocationCode;

  @observable
  bool _isCanceled = false;

  @action
  Future<void> setupTunnel() async {
    try {
      await _wireguardService.setupTunnel(
        bundleId: _env.getBundleId(),
        win32ServiceName: win32ServiceName,
      );
      debugPrint('Tunnel setup done');
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar('Error occured while setting up tunnel');
    }
  }

  @action
  Future<void> setVpnConfigConsent({required bool value}) async {
    await _localDBService.setVpnConsentApproval(approval: value);
    _vpnConfigConsent = value;
    if (_vpnConfigConsent ?? false) {
      setupTunnel();
    }
  }

  @action
  Future<void> toggleResetConnection() async {
    await _localDBService.setResetConnection(resetConnection: !_resetConnection);
    _resetConnection = !_resetConnection;
  }

  @action
  Future<void> generateKey() async {
    if (await _securedStorage.checkExistance(StorageKeys.wireguardPrivateKey.value) &&
        await _securedStorage.checkExistance(StorageKeys.wireguardPublicKey.value)) {
      _privateKey = await _securedStorage.read(StorageKeys.wireguardPrivateKey.value);
      _publicKey = await _securedStorage.read(StorageKeys.wireguardPublicKey.value);
    } else {
      final res = await _wireguardService.generateKeyPair();
      _privateKey = res['privateKey'] ?? '';
      _publicKey = res['publicKey'] ?? '';
      await _securedStorage.write(StorageKeys.wireguardPrivateKey.value, _privateKey);
      await _securedStorage.write(StorageKeys.wireguardPublicKey.value, _publicKey);
    }
  }

  @action
  Future<void> cancelConnection() async {
    if (_connectionStatus == ConnectionStatus.connecting) {
      await _cancelableOperation?.cancel();
      _isCanceled = true;
    }
  }

  @action
  Future<void> connectWireguard() async {
    final config = _vpnConfig?.config;
    if (config == null) {
      return;
    }
    try {
      await _wireguardService.connect(cfg: config).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Wireguard connection timeout'),
          );
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw WireguardConnectException(e.toString());
    }
  }

  @action
  Future<void> disconnectWireguard() async {
    await _wireguardService.disconnect().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Wireguard disconnection timeout'),
        );
  }

  @action
  Future<void> connect({
    String? location,
    bool? refreshIP,
  }) async {
    if (_subscriptionStore.subscriptionFuture?.status == FutureStatus.pending) {
      showSnackbar(
        LocaleKeys.checkingSubsStatus.tr(),
      );
      return;
    }
    if (_subscriptionStore.subscription?.active == false ||
        _subscriptionStore.subscriptionFuture?.status == FutureStatus.rejected) {
      _subscriptionStore.fetchSubscription();
      showSnackbar(LocaleKeys.activateSubscription.tr());
      return;
    }
    if (isLoading) {
      cancelConnection();
      return;
    }

    if (refreshIP != true &&
        _connectionStatus == ConnectionStatus.connected &&
        (location == null || location == _vpnConnection?.location)) {
      await disconnect();
      return;
    }

    location ??= refreshIP ?? false ? _vpnConnection?.location : selectLocation();
    _connectingLocationCode = location;

    try {
      if (_vpnConnection != null) {
        await disconnect();
      }
      final stopwatch = Stopwatch()..start();
      _connectionStatus = ConnectionStatus.connecting;
      _isCanceled = false;
      _cancelableOperation = CancelableOperation.fromFuture(
        _completeConnection(location, stopwatch, refreshIP),
        onCancel: () async {
          stopwatch.stop();
          await Future.delayed(const Duration(seconds: 2), disconnect);
          _connectionStatus = ConnectionStatus.disconnected;
        },
      );
      final vpnConnection = await _cancelableOperation?.value;
      _vpnConnection = vpnConnection;

      _connectionStatus = ConnectionStatus.connected;
      stopwatch.stop();
      _analyticsStore.setVpnConnect(
        vpnServer: _vpnConnection?.location ?? '',
        vpnProcessingTime: stopwatch.elapsed,
      );
      _locationsStore.addRecentLocation(vpnConnection!.location);
    } on TimeoutException catch (e) {
      showSnackbar(
        LocaleKeys.connectionTimeout.tr(),
      );
      setVpnError(
        errorCode: 408,
        errorMessage: e.message ?? '',
        errorSource: 'wireguard',
      );
    } on OperationCancelledException {
      debugPrint('Operation cancelled by user');
    } catch (e) {
      final errorMessage = e is ApiException
          ? e.message
          : LocaleKeys.failedToConnect.tr(
              namedArgs: {
                'countryName': location?.tr() ?? '',
              },
            );
      final errorCode = e is WireguardConnectException
          ? e.code
          : e is ApiException
              ? e.code
              : 500;
      final errorSource = e is WireguardConnectException
          ? 'wireguard'
          : e is ApiException
              ? 'backend'
              : 'internal';

      showSnackbar(errorMessage);
      setVpnError(
        errorCode: errorCode,
        errorMessage: errorMessage,
        errorSource: errorSource,
      );
      _connectionStatus = ConnectionStatus.disconnected;
    }
  }

  String? selectLocation() {
    if (_locationsStore.vpnLocations.allLocations.isEmpty ||
        _locationsStore.vpnLocations.topLocations.isEmpty) {
      return null;
    }
    if (_locationsStore.recentLocations.isNotEmpty) {
      return _locationsStore.recentLocations.first;
    }
    if (_locationsStore.vpnLocations.topLocations.isNotEmpty) {
      return _locationsStore.vpnLocations.topLocations.randomItem();
    }
    return _locationsStore.vpnLocations.allLocations.randomItem();
  }

  Future<void> setVpnError({
    required int errorCode,
    required String errorMessage,
    required String errorSource,
  }) async {
    await _analyticsStore.setVpnError(
      errorCode: errorCode,
      errorMessage: errorMessage,
      errorSource: errorSource,
    );
  }

  @action
  Future<VpnConnection> _completeConnection(
    String? location,
    Stopwatch stopwatch,
    bool? refreshIP,
  ) async {
    try {
      if (_publicKey.isEmpty || _privateKey.isEmpty) {
        await generateKey();
      }
      _vpnConfig = await _apiService.fetchVpnConfig(
        input: VpnConfigInput(
          publicKey: _publicKey,
          country: location,
          resetConnection: refreshIP ?? _resetConnection,
          osType: Platform.operatingSystem,
        ),
        privateKey: _privateKey,
      );
      debugPrint(_vpnConfig?.config);
      if (!_isCanceled) {
        await connectWireguard();
        final ipAddress = await _apiService.getIPAdress().timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw BrokenNodeException(),
            );
        return VpnConnection(
          connectionIP: ipAddress ?? '--',
          location: location ?? '',
        );
      } else {
        throw OperationCancelledException();
      }
    } on BrokenNodeException {
      disconnect();
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> disconnect() async {
    if (_connectionStatus != ConnectionStatus.connected &&
        _connectionStatus != ConnectionStatus.connecting) {
      return;
    }
    _connectionStatus = ConnectionStatus.disconnecting;
    await Future.delayed(const Duration(seconds: 1));
    await disconnectWireguard();
    _analyticsStore.setVpnDisconnect(vpnServer: _vpnConnection?.location ?? '');
    _vpnConnection = null;
    _vpnConfig = null;
    _timer?.cancel();

    _connectionStatus = ConnectionStatus.disconnected;
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }
}
