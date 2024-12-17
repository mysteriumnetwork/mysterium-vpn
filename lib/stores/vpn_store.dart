// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/report_broken_node_request.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/connection_status.dart';
import 'package:wireguard_dart/key_pair.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

// Project imports:

part 'vpn_store.g.dart';

// Regular expression pattern to match lines containing "DNS"
final dnsRegex = RegExp(r'.*(\DNS\b).*', caseSensitive: false);

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore({
    required ApiService apiService,
    required LocationsStore locationsStore,
    required WireguardDart wireguardService,
    required SubscriptionStore subscriptionStore,
    required FlavorConfig env,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _subscriptionStore = subscriptionStore,
        _env = env,
        _analyticsStore = analyticsStore,
        _remoteConfigStore = remoteConfigStore,
        _logger = logger {
    _init();
  }

  final ApiService _apiService;
  final LocationsStore _locationsStore;
  final AnalyticsStore _analyticsStore;
  final WireguardDart _wireguardService;
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;

  final FlavorConfig _env;
  final _securedStorage = SecureStorageService.instance;
  final _sharedPrefs = SharedPreferenceService.instance;
  final LocalDBService _localDBService = LocalDBService.instance;
  final Talker _logger;
  final Stopwatch _stopwatch = Stopwatch();

  @readonly
  bool _refreshIPConnection = true;

  @readonly
  bool _malwareBlockerContent = false;

  @readonly
  bool _notSafeContentBlocker = false;

  @readonly
  bool? _vpnConfigConsent;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  WireguardConnectResponse? _vpnConfig;

  KeyPair? _wireguardKey;

  String _connectingNonce = '';

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  String? get replaceDNSAddress {
    String? replaceDNS;
    if (!_remoteConfigStore.hideNotSafeContentBlocker && _notSafeContentBlocker) {
      replaceDNS = _remoteConfigStore.notSafeContentBlockerDnsAddress;
    } else if (!_remoteConfigStore.hideMalwareBlocker && _malwareBlockerContent) {
      replaceDNS = _remoteConfigStore.malwareBlockerDnsAddress;
    }
    return replaceDNS;
  }

  @computed
  bool get isConnected =>
      _connectionStatus == ConnectionStatus.connected &&
      resolveConnectionLocationFuture?.status != FutureStatus.pending &&
      fetchConfigFuture?.status != FutureStatus.pending;

  @computed
  bool get isLoading =>
      _connectionStatus == ConnectionStatus.connecting ||
      resolveConnectionLocationFuture?.status == FutureStatus.pending ||
      fetchConfigFuture?.status == FutureStatus.pending;

  @readonly
  String? _connectingLocationCode;

  bool _isTunnelSetup = false;

  @observable
  ObservableFuture<void>? resolveConnectionLocationFuture;

  @observable
  ObservableFuture<WireguardConnectResponse>? fetchConfigFuture;

  int _retryCount = 0;
  bool _isRetrying = false;
  String? originCountry;

  Future<void> _init() async {
    _vpnConfigConsent = await _localDBService.getVpnConsentApproval() ?? false;
    if (_vpnConfigConsent ?? false) {
      await _setupTunnel().whenComplete(_setupAndListenToConnectionStatus);
    }

    _refreshIPConnection = await _localDBService.getRefreshIPConnection();
    _malwareBlockerContent = await _localDBService.getMalwareBlocker();
    _notSafeContentBlocker = await _localDBService.getNotSafeContentBlocker();

    await _initWireguardKey();
  }

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocationCode = '';
    final status = await _wireguardService.status();

    if (status == ConnectionStatus.connected) {
      _connectionStatus = ConnectionStatus.connecting;
      try {
        final location = _sharedPrefs.getLocationCode();
        _connectingNonce = generateRandomString(8);
        resolveConnectionLocationFuture = ObservableFuture(
          _checkConnectionQuality(
            checkLocation: () async {
              _resolveIPAddress(location, _connectingNonce);
            },
            location: location,
            nonce: _connectingNonce,
            hash: _vpnConfig?.hash ?? '',
          ),
        );
        await resolveConnectionLocationFuture;
      } catch (e) {
        disconnectWireguard();
      }
    } else {
      originCountry = (await _apiService.getIPAdress())?.country;
    }

    _connectionStatus = status;

    _wireguardService.statusStream().listen((event) async {
      if (event == ConnectionStatus.disconnecting) {
        _vpnConnection = null;
      }

      if (event == ConnectionStatus.unknown) {
        _isTunnelSetup = false;
        _setupTunnel();
      }
      _connectionStatus = event;
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
      var message = 'Error occured while setting up tunnel';
      if (e is PlatformException) {
        if ((e.message?.contains('Permissions are not given') ?? false) ||
            (e.message?.contains('permission denied') ?? false)) {
          message = 'You need to grant permission to start VPN tunnel.';
        }
      }

      _isTunnelSetup = false;
      _logger.handle(e, stackTrace);
      showSnackbar(message);
      rethrow;
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

  @action
  Future<void> toggleRefreshIPWhenConnecting() async {
    await _localDBService.setRefreshIPConnection(
      refreshIPConnection: !_refreshIPConnection,
    );
    _refreshIPConnection = !_refreshIPConnection;
  }

  @action
  Future<void> toggleMalwareBlocker() async {
    await _localDBService.setMalwareBlocker(
      malwareBlocker: !_malwareBlockerContent,
    );
    _malwareBlockerContent = !_malwareBlockerContent;
  }

  @action
  Future<void> toggleNotSafeContentBlocker() async {
    await _localDBService.setNotSafeContentBlocker(
      notSafeContentBlocker: !_notSafeContentBlocker,
    );
    _notSafeContentBlocker = !_notSafeContentBlocker;
  }

  @action
  Future<KeyPair> _initWireguardKey() async {
    try {
      final res = await Future.wait([
        _securedStorage.checkExistance(StorageKeys.wireguardPrivateKey.name),
        _securedStorage.checkExistance(StorageKeys.wireguardPublicKey.name),
      ]);
      final key = await _wireguardService.generateKeyPair();

      if (res.contains(false)) {
        await Future.wait([
          _securedStorage.saveWireguardPublicKey(
            publicKey: key.publicKey,
          ),
          _securedStorage.saveWireguardPrivateKey(
            privateKey: key.privateKey,
          ),
        ]);
        return _wireguardKey = key;
      } else {
        final publicKey = await _securedStorage.getWireguardPublicKey();
        final privateKey = await _securedStorage.getWireguardPrivateKey();
        return _wireguardKey = KeyPair(publicKey, privateKey);
      }
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  /// Connect to Wireguard tunnel
  @action
  Future<void> _connectWireguard({
    required String privateKey,
    required String nonce,
  }) async {
    if (_vpnConfig == null) {
      return;
    }
    // TODO(Waldz): Move to separate function, which mutates variable
    var config = _vpnConfig!.wgConfig;
    if (replaceDNSAddress.isNotNullOrEmpty) {
      // Find all matches in the content
      final match = dnsRegex.firstMatch(config);
      if (match?[0] != null) {
        final dnsLine = match![0]!;
        config = config.replaceFirst(dnsLine, 'DNS = $replaceDNSAddress');
      }
    }
    config = config.replaceFirst('%private_key%', privateKey);

    try {
      final tunnelStatus = await _wireguardService.status();
      if (tunnelStatus == ConnectionStatus.connected ||
          tunnelStatus == ConnectionStatus.connecting) {
        await _wireguardService.disconnect();
      }
      await Future.doWhile(
        () async => !(await _wireguardService.status() == ConnectionStatus.disconnected),
      );
      if (_connectingNonce != nonce) {
        return;
      }
      await _wireguardService.connect(cfg: config).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Wireguard connection timeout'),
          );
    } on TimeoutException catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      if (e is PlatformException) {
        if ((e.message?.contains('Permissions are not given') ?? false) ||
            (e.message?.contains('permission denied') ?? false) ||
            (e.message?.contains('tunnel not initialized') ?? false)) {
          _setupTunnel();
        }
      }
      _logger.handle(e, stackTrace);
      throw WireguardConnectException(e.toString());
    }
  }

  /// Disconnect from Wireguard tunnel
  @action
  Future<void> disconnectWireguard() async {
    final tunnelStatus = await _wireguardService.status();
    if (tunnelStatus == ConnectionStatus.connected || tunnelStatus == ConnectionStatus.connecting) {
      await _wireguardService.disconnect().timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Wireguard disconnection timeout'),
          );
    }
  }

  Future<bool> _checkSubscriptionStatus() async {
    if (_subscriptionStore.subscriptionFuture?.status == FutureStatus.pending) {
      showSnackbar(LocaleKeys.checkingSubsStatus.tr());
      await _subscriptionStore.subscriptionFuture;
    } else {
      await _subscriptionStore.fetchSubscription();
    }
    return _subscriptionStore.subscription?.active ?? false;
  }

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({String? location, bool isRetrying = false}) async {
    if (_connectionStatus == ConnectionStatus.connected &&
        (location == null || location == _vpnConnection?.location)) {
      await disconnectWireguard();
      _connectingLocationCode = '';
      return;
    }

    if (isLoading && (_connectingLocationCode?.isNotEmpty ?? false) && !isRetrying) {
      if (_connectingLocationCode == location || location == null) {
        _cancelConnection();
        return;
      }
    }

    if (!_isTunnelSetup || await _wireguardService.status() == ConnectionStatus.unknown) {
      await _setupTunnel();
    }
    await startConnection(location: location, isRetrying: isRetrying);
  }

  /// Connect to VPN by refreshing IP address
  @action
  Future<void> startConnectionWithRefreshIP() async {
    await startConnection(refreshIP: true);
  }

  /// Connect to VPN
  @action
  Future<void> startConnection({
    String? location,
    bool? refreshIP,
    bool isRetrying = false,
  }) async {
    if (!await _checkSubscriptionStatus()) {
      throw const SubscriptionRequiredException();
    }

    _connectingNonce = generateRandomString(8);

    location ??= refreshIP ?? false ? _vpnConnection?.location : _selectLocation();
    _connectingLocationCode = location;

    try {
      if (_connectionStatus == ConnectionStatus.connected) {
        await disconnectWireguard();
      }

      await _completeConnection(location, refreshIP, _connectingNonce);

      _stopwatch.stop();
      _analyticsStore.logEvent(
        AnalyticsEvent.connectSuccess,
        parameters: {
          'location': _vpnConnection!.location,
          'time': _stopwatch.elapsed.inSeconds,
          'refresh_ip': refreshIP,
        },
      );
      _locationsStore.addRecentLocation(_vpnConnection!.location);
    } on TimeoutException catch (e, stackTrace) {
      _logger.handle(e);
      Sentry.captureException(e, stackTrace: stackTrace);

      showSnackbar(
        LocaleKeys.connectionTimeout.tr(),
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.connectError,
        parameters: {
          'time': _stopwatch.elapsed.inSeconds,
          'error': e.message,
          'error_type': e.runtimeType.toString(),
        },
      );
      _stopwatch.stop();
    } on OperationCancelledException {
      _logger.info('Operation cancelled by user');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      Sentry.captureException(e, stackTrace: stackTrace);

      if (e is BrokenNodeException && _isRetrying == true) {
        return;
      }

      final errorCode = e is WireguardConnectException
          ? e.code
          : e is ApiException
              ? e.code
              : e is BrokenNodeException
                  ? e.code
                  : 1113;
      final errorMessage = LocaleKeys.failedToConnectError.tr(
        namedArgs: {
          'errorCode': errorCode.toString(),
        },
      );
      if (_isRetrying == true) {
        return;
      }
      showSnackbar(errorMessage);
      _analyticsStore.logEvent(
        AnalyticsEvent.connectError,
        parameters: {
          'time': _stopwatch.elapsed.inSeconds,
          'error': e.toString(),
          'error_type': e.runtimeType.toString(),
          'error_code': errorCode,
          'error_message': errorMessage,
        },
      );

      _connectionStatus = ConnectionStatus.disconnected;
    } finally {
      _stopwatch.stop();
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

  @action
  void _checkOperationCancel(String nonce) {
    if (_connectingNonce != nonce) {
      throw OperationCancelledException();
    }
  }

  void _cancelConnection() {
    var counter = 0;
    Future.doWhile(() async {
      counter++;
      final status = await _wireguardService.status();
      if (status == ConnectionStatus.connected) {
        disconnectWireguard();
      } else if (_connectionStatus == ConnectionStatus.connecting && status != _connectionStatus) {
        _connectionStatus = ConnectionStatus.disconnected;
      }
      return counter < 5 && status != ConnectionStatus.connected;
    });
  }

  @action
  Future<void> _completeConnection(
    String? location,
    bool? refreshIP,
    String nonce,
  ) async {
    try {
      final key = _wireguardKey ?? await _initWireguardKey();
      _stopwatch
        ..reset()
        ..start();
      fetchConfigFuture = ObservableFuture(
        _apiService.fetchVpnConfig(
          request: WireguardConnectRequest(
            publicKey: key.publicKey,
            country: location,
            resetConnection: refreshIP ?? _refreshIPConnection,
            osType: Platform.operatingSystem,
          ),
        ),
      );
      _vpnConfig = await fetchConfigFuture;
      _checkOperationCancel(nonce);
      _connectionStatus = ConnectionStatus.connecting;
      await _connectWireguard(privateKey: key.privateKey, nonce: nonce);

      _checkOperationCancel(nonce);
      resolveConnectionLocationFuture = ObservableFuture(
        _checkConnectionQuality(
          checkLocation: () async {
            if (_vpnConfig?.exitIp != null) {
              _vpnConnection = _vpnConnection?.copyWith(connectionIP: _vpnConfig!.exitIp!);
              return;
            }
            _resolveIPAddress(location, _connectingNonce);
          },
          location: location,
          nonce: nonce,
          hash: _vpnConfig?.hash ?? '',
        ),
      );
      await resolveConnectionLocationFuture!;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  Future<void> _checkConnectionQuality({
    required Future<void> Function() checkLocation,
    required String? location,
    required String nonce,
    required String hash,
  }) async {
    try {
      await Future.doWhile(
        () async =>
            !(await _wireguardService.status() == ConnectionStatus.connected) &&
            _connectingNonce == nonce,
      );

      _checkOperationCancel(nonce);
      if (!await hasNetwork(interval: 5, timeout: 10)) {
        if (_connectingNonce == nonce) {
          throw BrokenNodeException(location ?? '');
        }
      }

      _checkOperationCancel(nonce);
      await _sharedPrefs.setLocationCode(location ?? '');

      _vpnConnection = VpnConnection(connectionIP: '', location: location ?? '');
      await checkLocation();

      _retryCount = 0;
      _isRetrying = false;
    } on BrokenNodeException {
      _retryCount++;
      _isRetrying = true;
      await disconnectWireguard();

      if (_retryCount < 3) {
        toggleConnection(location: location, isRetrying: true);
      } else {
        _retryCount = 0;
        _isRetrying = false;
      }
      if (_vpnConfig?.hashCode != null) {
        unawaited(
          _apiService.reportBrokenNode(
            request: ReportBrokenNodeRequest(
              publicKey: _wireguardKey!.publicKey,
              destinationCountry: location ?? '',
              osType: Platform.operatingSystem,
              appVersion: (await PackageInfo.fromPlatform()).version,
              originCountry: originCountry,
              connectivityType: (await Connectivity().checkConnectivity()).lastOrNull,
              hashValue: _vpnConfig!.hash,
            ),
          ),
        );
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _resolveIPAddress(String? countryCode, String nonce) async {
    var counter = 0;
    var resolvedIPAddress = '';
    await Future.doWhile(() async {
      // If user changed location while resolving IP, stop the process
      if (nonce != _connectingNonce) {
        return false;
      }
      counter++;
      await Future.delayed(const Duration(seconds: 3));
      final ipInfo = await _apiService.getIPAdress().timeout(
            const Duration(seconds: 10),
            onTimeout: () => null,
          );
      if (ipInfo != null && ipInfo.country == countryCode) {
        resolvedIPAddress = ipInfo.ip;
      }
      return counter < 5 && resolvedIPAddress.isEmpty;
    });
    if (nonce != _connectingNonce) {
      return;
    }
    if (resolvedIPAddress.isNotEmpty) {
      _vpnConnection = _vpnConnection?.copyWith(connectionIP: resolvedIPAddress);
    }
    // If IP address is not resolved, disconnect the connection
    else if ((_vpnConnection?.connectionIP.isEmpty ?? true) &&
        _connectingLocationCode == countryCode) {
      disconnectWireguard();
      _vpnConnection = null;
    }
  }
}
