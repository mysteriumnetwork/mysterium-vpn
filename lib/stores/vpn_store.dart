// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/location.dart';
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
    _protocol = protocols.first;
    _killSwitch = true;
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

  @observable
  ObservableFuture<void> setupTunnelFuture = ObservableFuture.value(null);

  CancelableOperation<void>? _cancelableOperation;

  @readonly
  Duration? _duration;
  @readonly
  double? _uploadSpeed;
  @readonly
  double? _downloadSpeed;
  @readonly
  String _protocol = protocols.first;
  @readonly
  bool _killSwitch = true;

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
      _connectionStatus == ConnectionStatus.disconnecting || _connectionStatus == ConnectionStatus.connecting;
  @readonly
  String? _connectingLocationCode;

  @observable
  bool _isCanceled = false;

  @action
  Future<void> setupTunnel() async {
    try {
      setupTunnelFuture = ObservableFuture(
        _wireguardService.setupTunnel(
          bundleId: _env.getBundleId(),
          win32ServiceName: win32ServiceName,
        ),
      );
      await setupTunnelFuture;
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
    Location? location,
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
        (location == null || location.countryCode == _vpnConnection?.location.countryCode)) {
      await disconnect();
      return;
    }

    location ??= refreshIP ?? false
        ? _vpnConnection?.location
        : _locationsStore.vpnLocations.allLocations.isNotEmpty
            ? [..._locationsStore.vpnLocations.allLocations, ..._locationsStore.vpnLocations.topLocations].randomItem()
            : null;
    _connectingLocationCode = location?.countryCode;

    try {
      if (_vpnConnection != null) {
        await disconnect();
      }
      final stopwatch = Stopwatch()..start();
      _connectionStatus = ConnectionStatus.connecting;
      _isCanceled = false;
      // ignore: void_checks
      _cancelableOperation = CancelableOperation.fromFuture(
        _completeConnection(location, stopwatch, refreshIP),
        onCancel: () async {
          stopwatch.stop();
          await Future.delayed(const Duration(seconds: 2), disconnect);
          _connectionStatus = ConnectionStatus.disconnected;
        },
      );
      await _cancelableOperation?.value;
    } on TimeoutException {
      await disconnectWireguard();
      showSnackbar(
        LocaleKeys.connectionTimeout.tr(),
      );
      _connectionStatus = ConnectionStatus.disconnected;
    } catch (e) {
      if (e is ApiException) {
        showSnackbar(e.message);
      }
      showSnackbar(
        LocaleKeys.failedToConnect.tr(
          namedArgs: {
            'countryName': location?.countryName ?? '',
          },
        ),
      );
      _connectionStatus = ConnectionStatus.disconnected;
      if (e is WireguardConnectException) {
        _analyticsStore.setVpnError(
          errorCode: e.code,
          errorMessage: e.message,
          errorSource: 'wireguard',
        );
      } else if (e is ApiException) {
        _analyticsStore.setVpnError(
          errorCode: e.code,
          errorMessage: e.message,
          errorSource: 'backend',
        );
      } else {
        _analyticsStore.setVpnError(
          errorCode: 500,
          errorMessage: e.toString(),
          errorSource: 'internal',
        );
      }
    }
  }

  @action
  Future<void> _completeConnection(
    Location? location,
    Stopwatch stopwatch,
    bool? refreshIP,
  ) async {
    if (_publicKey.isEmpty || _privateKey.isEmpty) {
      await generateKey();
    }
    _vpnConfig = await _apiService.fetchVpnConfig(
      input: VpnConfigInput(
        publicKey: _publicKey,
        country: location?.countryCode,
        resetConnection: refreshIP ?? _resetConnection,
      ),
      privateKey: _privateKey,
    );
    debugPrint(_vpnConfig?.config);
    if (!_isCanceled) {
      try {
        await connectWireguard();
        final ipAddress = await _apiService.getIPAdress().timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException('IP address timeout'),
            );
        _vpnConnection = VpnConnection(
          connectionIP: ipAddress ?? '--',
          location: location!,
        );
      } catch (e) {
        showSnackbar(
          LocaleKeys.failedToConnect.tr(
            namedArgs: {
              'countryName': location?.countryName ?? '',
            },
          ),
        );
        await disconnect();
        return;
      }

      _connectionStatus = ConnectionStatus.connected;
      stopwatch.stop();
      _analyticsStore.setVpnConnect(
        vpnServer: _vpnConnection?.location.countryCode ?? '',
        vpnProcessingTime: stopwatch.elapsed,
      );
      _apiService.setRecentLocation(location: location.countryCode);
      _locationsStore.fetchRecentLocations();
    }
  }

  @action
  Future<void> changeProtocol(String protocol) async {
    _protocol = protocol;
  }

  @action
  Future<void> toggleKillSwitch() async {
    _killSwitch = !_killSwitch;
  }

  @action
  Future<void> startTracking() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _duration = Duration(seconds: (_duration?.inSeconds ?? 0) + 1);
      _uploadSpeed = random.nextDouble() * 600;
      _downloadSpeed = random.nextDouble() * 600;
    });
  }

  @action
  Future<void> disconnect() async {
    if (_connectionStatus != ConnectionStatus.connected && _connectionStatus != ConnectionStatus.connecting) {
      return;
    }
    _connectionStatus = ConnectionStatus.disconnecting;
    await Future.delayed(const Duration(seconds: 1));
    await disconnectWireguard();
    _analyticsStore.setVpnDisconnect(vpnServer: _vpnConnection?.location.countryCode ?? '');
    _vpnConnection = null;
    _timer?.cancel();
    _downloadSpeed = null;
    _uploadSpeed = null;
    _duration = null;
    _connectionStatus = ConnectionStatus.disconnected;
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }
}
