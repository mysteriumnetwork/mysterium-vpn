// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:talker/talker.dart';
import 'package:wireguard_dart/connection_status.dart';
import 'package:wireguard_dart/key_pair.dart';
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
    required Talker logger,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _analyticsStore = analyticsStore,
        _subscriptionStore = subscriptionStore,
        _localDBService = localDBService,
        _env = env,
        _logger = logger {
    _init();
  }

  final ApiService _apiService;
  final LocationsStore _locationsStore;
  final WireguardDart _wireguardService;
  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final FlavorConfig _env;
  final _securedStorage = SecureStorageService.instance;
  final _sharedPrefs = SharedPreferenceService.instance;
  final LocalDBService _localDBService;
  final Talker _logger;

  Timer? _timer;

  CancelableOperation<VpnConnection>? _cancelableOperation;

  @readonly
  bool _refreshIPConnection = true;

  @readonly
  bool? _requestedRefreshIP;

  @readonly
  bool? _vpnConfigConsent;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  VpnConfig? _vpnConfig;

  KeyPair? _wireguardKey;

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  bool get isConnected => _connectionStatus == ConnectionStatus.connected;
  @computed
  bool get isLoading => _connectionStatus == ConnectionStatus.connecting;

  @readonly
  String? _connectingLocationCode;

  @observable
  bool _isCanceled = false;

  bool _isTunnelSetup = false;

  @observable
  ObservableFuture<VpnConnection>? createVPNConnectingLocaitonFuture;

  Future<void> _init() async {
    await _generateKey();
    _vpnConfigConsent = _localDBService.getVpnConsentApproval() ?? false;
    _refreshIPConnection = _localDBService.getRefreshIPConnection();
    if (_vpnConfigConsent ?? false) {
      await _setupTunnel().whenComplete(_setupAndListenToConnectionStatus);
    }
  }

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocationCode = '';
    final status = await _wireguardService.status();
    if (status == ConnectionStatus.connected) {
      _connectionStatus = ConnectionStatus.connecting;
      final location = _sharedPrefs.getLocationCode();
      createVPNConnectingLocaitonFuture = ObservableFuture(_createVPNConnectionLocaiton(location));
      _vpnConnection = await createVPNConnectingLocaitonFuture;
    }
    _connectionStatus = status;

    _wireguardService.statusStream().listen((event) {
      if (!(createVPNConnectingLocaitonFuture?.status == FutureStatus.pending ||
          (_requestedRefreshIP ?? true && _connectionStatus == ConnectionStatus.connecting))) {
        _connectionStatus = event;
      }
      if (event == ConnectionStatus.disconnected) {
        _vpnConnection = null;
        _vpnConfig = null;
        _analyticsStore.setVpnDisconnect(vpnServer: _vpnConnection?.location ?? '');
      }
    });
  }

  /// Setup Wireguard tunnel
  @action
  Future<void> _setupTunnel() async {
    try {
      if (_isTunnelSetup) {
        return;
      }
      await _wireguardService.setupTunnel(
        bundleId: _env.getBundleId(),
        win32ServiceName: win32ServiceName,
        tunnelName: _env.values.tunnelName,
      );
      _isTunnelSetup = true;
      _logger.info('Tunnel setup done');
    } catch (e, stackTrace) {
      _isTunnelSetup = false;
      _logger.handle(e, stackTrace);
      showSnackbar('Error occured while setting up tunnel');
    }
  }

  @action
  Future<void> setVpnConfigConsent({required bool value}) async {
    await _localDBService.setVpnConsentApproval(approval: value);
    _vpnConfigConsent = value;
    if (_vpnConfigConsent ?? false) {
      await _setupTunnel().whenComplete(_setupAndListenToConnectionStatus);
    }
  }

  ///
  @action
  Future<void> toggleRefreshIPWhenConnecting() async {
    await _localDBService.setRefreshIPConnection(refreshIPConnection: !_refreshIPConnection);
    _refreshIPConnection = !_refreshIPConnection;
  }

  @action
  Future<void> _generateKey() async {
    final res = await Future.wait([
      _securedStorage.checkExistance(StorageKeys.wireguardPrivateKey.name),
      _securedStorage.checkExistance(StorageKeys.wireguardPublicKey.name),
    ]);
    if (res.contains(false)) {
      _wireguardKey = await _wireguardService.generateKeyPair();
      await Future.wait([
        _securedStorage.write(StorageKeys.wireguardPrivateKey.name, _wireguardKey!.privateKey),
        _securedStorage.write(StorageKeys.wireguardPublicKey.name, _wireguardKey!.publicKey),
      ]);
    } else {
      final res = await Future.wait([
        _securedStorage.read(StorageKeys.wireguardPublicKey.name),
        _securedStorage.read(StorageKeys.wireguardPrivateKey.name),
      ]);
      _wireguardKey = KeyPair(res[0], res[1]);
    }
  }

  @action
  Future<void> _cancelConnection() async {
    if (_connectionStatus == ConnectionStatus.connecting) {
      await _cancelableOperation?.cancel();
      _isCanceled = true;
    }
  }

  /// Connect to Wireguard tunnel
  @action
  Future<void> _connectWireguard() async {
    final config = _vpnConfig?.config;
    if (config == null) {
      return;
    }
    try {
      await _wireguardService.connect(cfg: config).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Wireguard connection timeout'),
          );
    } on TimeoutException catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      throw WireguardConnectException(e.toString());
    }
  }

  /// Disconnect from Wireguard tunnel
  @action
  Future<void> disconnectWireguard() async {
    await _wireguardService.disconnect().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Wireguard disconnection timeout'),
        );
  }

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({
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
    _requestedRefreshIP = refreshIP;
    if (isLoading) {
      _cancelConnection();
      return;
    }

    if (refreshIP != true &&
        _connectionStatus == ConnectionStatus.connected &&
        (location == null || location == _vpnConnection?.location)) {
      await disconnectWireguard();
      return;
    }

    location ??= refreshIP ?? false ? _vpnConnection!.location : _selectLocation();
    _connectingLocationCode = location;

    try {
      if (_vpnConnection != null) {
        await disconnectWireguard();
      }
      final stopwatch = Stopwatch()..start();
      _connectionStatus = ConnectionStatus.connecting;
      _isCanceled = false;
      _cancelableOperation = CancelableOperation.fromFuture(
        _completeConnection(location, stopwatch, refreshIP),
        onCancel: () async {
          stopwatch.stop();
          await Future.delayed(const Duration(seconds: 2), disconnectWireguard);
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
      _logger.handle(e);
      showSnackbar(
        LocaleKeys.connectionTimeout.tr(),
      );
      _setVpnError(
        errorCode: 408,
        errorMessage: e.message ?? '',
        errorSource: 'wireguard',
      );
    } on OperationCancelledException {
      _logger.info('Operation cancelled by user');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
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
      _setVpnError(
        errorCode: errorCode,
        errorMessage: errorMessage,
        errorSource: errorSource,
      );
      _connectionStatus = ConnectionStatus.disconnected;
    }
  }

  String? _selectLocation() {
    if (_locationsStore.vpnLocations.allLocations.isEmpty &&
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

  Future<void> _setVpnError({
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
      if (_wireguardKey == null) {
        await _generateKey();
      }
      _vpnConfig = await _apiService.fetchVpnConfig(
        input: VpnConfigInput(
          publicKey: _wireguardKey!.publicKey,
          country: location,
          resetConnection: refreshIP ?? _refreshIPConnection,
          osType: Platform.operatingSystem,
        ),
        privateKey: _wireguardKey!.privateKey,
      );
      if (!_isCanceled) {
        await _connectWireguard();
        createVPNConnectingLocaitonFuture =
            ObservableFuture(_createVPNConnectionLocaiton(location));
        return await createVPNConnectingLocaitonFuture!;
      } else {
        throw OperationCancelledException();
      }
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  Future<VpnConnection> _createVPNConnectionLocaiton(String? location) async {
    try {
      final ipAddress = await _apiService.getIPAdress().timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw BrokenNodeException(location ?? ''),
          );
      await _sharedPrefs.setLocationCode(location ?? '');
      return VpnConnection(
        connectionIP: ipAddress ?? '--',
        location: location ?? '',
      );
    } on BrokenNodeException {
      disconnectWireguard();
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }
}
