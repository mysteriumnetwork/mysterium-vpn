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
import 'package:mysterium_vpn/models/vpn_config.dart';
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
    required SubscriptionStore subscriptionStore,
    required LocalDBService localDBService,
    required FlavorConfig env,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _subscriptionStore = subscriptionStore,
        _localDBService = localDBService,
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
  final LocalDBService _localDBService;
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
  VpnConfig? _vpnConfig;

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
  ObservableFuture<VpnConnection>? resolveConnectionLocationFuture;

  @observable
  ObservableFuture<VpnConfig>? fetchConfigFuture;

  int _retryCount = 0;
  bool _isRetrying = false;
  String? originCountry;

  Future<void> _init() async {
    await _generateKey();
    _vpnConfigConsent = _localDBService.getVpnConsentApproval() ?? false;
    _refreshIPConnection = _localDBService.getRefreshIPConnection();
    _malwareBlockerContent = _localDBService.getMalwareBlocker();
    _notSafeContentBlocker = _localDBService.getNotSafeContentBlocker();
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
      try {
        final location = _sharedPrefs.getLocationCode();
        _connectingNonce = generateRandomString(8);
        resolveConnectionLocationFuture = ObservableFuture(
          _resolveConnectionLocation(
            location: location,
            nonce: _connectingNonce,
            hash: _vpnConfig?.hashValue ?? '',
          ),
        );
        _vpnConnection = await resolveConnectionLocationFuture;
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
  Future<void> _generateKey() async {
    try {
      final res = await Future.wait([
        _securedStorage.checkExistance(StorageKeys.wireguardPrivateKey.name),
        _securedStorage.checkExistance(StorageKeys.wireguardPublicKey.name),
      ]);
      if (res.contains(false)) {
        _wireguardKey = await _wireguardService.generateKeyPair();
        await Future.wait([
          _securedStorage.saveWireguardPublicKey(
            publicKey: _wireguardKey!.publicKey,
          ),
          _securedStorage.saveWireguardPrivateKey(
            privateKey: _wireguardKey!.privateKey,
          ),
        ]);
      } else {
        final publicKey = await _securedStorage.getWireguardPublicKey();
        final privateKey = await _securedStorage.getWireguardPrivateKey();
        _wireguardKey = KeyPair(publicKey, privateKey);
      }
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  /// Connect to Wireguard tunnel
  @action
  Future<void> _connectWireguard(
    String nonce,
  ) async {
    final config = _vpnConfig?.config;
    if (config == null) {
      return;
    }
    try {
      if (!_isTunnelSetup) {
        await _setupTunnel();
      }
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
      return false;
    }
    if (_subscriptionStore.subscription?.active == false ||
        _subscriptionStore.subscriptionFuture?.status == FutureStatus.rejected) {
      _subscriptionStore.fetchSubscription();
      showSnackbar(LocaleKeys.activateSubscription.tr());
      return false;
    }
    return true;
  }

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({
    String? location,
    bool? refreshIP,
    bool isRetrying = false,
  }) async {
    if (!await _checkSubscriptionStatus()) {
      return;
    }

    _connectingNonce = generateRandomString(8);
    if (isLoading &&
        (_connectingLocationCode?.isNotEmpty ?? false) &&
        !isRetrying &&
        refreshIP != true) {
      if (_connectingLocationCode == location || location == null) {
        var counter = 0;
        Future.doWhile(() async {
          counter++;
          final status = await _wireguardService.status();
          if (status == ConnectionStatus.connected) {
            disconnectWireguard();
          } else if (_connectionStatus == ConnectionStatus.connecting &&
              status != _connectionStatus) {
            _connectionStatus = ConnectionStatus.disconnected;
          }
          return counter < 5 && status != ConnectionStatus.connected;
        });
        return;
      }
    }

    if (refreshIP != true &&
        _connectionStatus == ConnectionStatus.connected &&
        (location == null || location == _vpnConnection?.location)) {
      await disconnectWireguard();
      _connectingLocationCode = '';
      return;
    }

    location ??= refreshIP ?? false ? _vpnConnection?.location : _selectLocation();
    _connectingLocationCode = location;

    try {
      if (_connectionStatus == ConnectionStatus.connected) {
        await disconnectWireguard();
      }

      final value = await _completeConnection(
        location,
        refreshIP,
        _connectingNonce,
      );

      _vpnConnection = value;
      _stopwatch.stop();
      _analyticsStore.logEvent(
        AnalyticsEvent.connectSuccess,
        parameters: {
          'location': value.location,
          'time': _stopwatch.elapsed.inSeconds,
          'refresh_ip': refreshIP,
        },
      );
      _locationsStore.addRecentLocation(value.location);
    } on TimeoutException catch (e) {
      _logger.handle(e);
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
      if (e is BrokenNodeException && _isRetrying == true) {
        return;
      }
      _logger.handle(e, stackTrace);
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
      if (errorCode == 7040) {
        _checkSubscriptionStatus();
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

  @action
  Future<VpnConnection> _completeConnection(
    String? location,
    bool? refreshIP,
    String nonce,
  ) async {
    try {
      _stopwatch
        ..reset()
        ..start();
      if (_wireguardKey == null) {
        await _generateKey();
      }
      fetchConfigFuture = ObservableFuture(
        _apiService.fetchVpnConfig(
          input: VpnConfigInput(
            publicKey: _wireguardKey!.publicKey,
            country: location,
            resetConnection: refreshIP ?? _refreshIPConnection,
            osType: Platform.operatingSystem,
          ),
          privateKey: _wireguardKey!.privateKey,
          replaceDNSAddress: replaceDNSAddress,
        ),
      );
      _vpnConfig = await fetchConfigFuture;
      _checkOperationCancel(nonce);
      _connectionStatus = ConnectionStatus.connecting;
      await _connectWireguard(nonce);
      _checkOperationCancel(nonce);
      resolveConnectionLocationFuture = ObservableFuture(
        _resolveConnectionLocation(
          location: location,
          nonce: nonce,
          hash: _vpnConfig?.hashValue ?? '',
        ),
      );
      return await resolveConnectionLocationFuture!;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  Future<VpnConnection> _resolveConnectionLocation({
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
      if (!await hasNetwork(interval: 5)) {
        if (_connectingNonce == nonce) {
          throw BrokenNodeException(location ?? '');
        }
      }
      _checkOperationCancel(nonce);
      await _sharedPrefs.setLocationCode(location ?? '');
      _resolveIPAddress(
        location,
        nonce,
      );
      _retryCount = 0;
      _isRetrying = false;
      return VpnConnection(
        connectionIP: '',
        location: location ?? '',
      );
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
              hashValue: _vpnConfig!.hashValue,
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
