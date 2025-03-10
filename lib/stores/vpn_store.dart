// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:convert';
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
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/report_broken_node_request.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
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
    required MQTTService mqtt,
    required LocationsStore locationsStore,
    required WireguardDart wireguardService,
    required SubscriptionStore subscriptionStore,
    required FlavorConfig env,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
  })  : _apiService = apiService,
        _mqtt = mqtt,
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
  final MQTTService _mqtt;
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
  StreamSubscription<String>? _connectionSub;

  @readonly
  bool _refreshIPConnection = true;

  @readonly
  bool _malwareBlockerContent = false;

  @readonly
  bool _notSafeContentBlocker = false;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  WireguardConnectResponse? _vpnConfig;

  KeyPair? _wireguardKey;

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  ConnectionStatus get vpnStatus => _connectionStatus == ConnectionStatus.unknown
      ? ConnectionStatus.disconnected
      : _connectionStatus;

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
      _fetchConfigFuture?.status != FutureStatus.pending;

  @computed
  bool get isLoading =>
      _connectionStatus == ConnectionStatus.connecting ||
      _fetchConfigFuture?.status == FutureStatus.pending;

  @readonly
  VPNLocation? _connectingLocation;

  @computed
  VPNLocation? get location => _vpnConnection?.location;

  @readonly
  ObservableFuture<void>? _resolveConnectionLocationFuture;

  @readonly
  ObservableFuture<WireguardConnectResponse>? _fetchConfigFuture;

  @readonly
  ObservableFuture<void>? _disconnectAllDevicesFuture;

  @readonly
  ObservableFuture<void>? _resetAppFuture;

  int _retryCount = 0;
  bool _isRetrying = false;

  @observable
  IPInfo? originIP;

  Future<void> _init() async {
    await Future.wait<void>(
      [
        _initTunnel(),
        _initWireguardKey(),
        _initRefreshIPConnection(),
        _initMalwareBlockerContent(),
        _initNotSafeContentBlocker(),
      ],
    );
  }

  Future<void> _initMalwareBlockerContent() async {
    try {
      _malwareBlockerContent = await _localDBService.getMalwareBlocker();
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> _initRefreshIPConnection() async {
    try {
      _refreshIPConnection = await _localDBService.getRefreshIPConnection();
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> _initNotSafeContentBlocker() async {
    try {
      _notSafeContentBlocker = await _localDBService.getNotSafeContentBlocker();
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> _initTunnel() async {
    try {
      final isConfigured = await _checkTunelConfigured();
      if (isConfigured) {
        await _setupAndListenToConnectionStatus();
      } else if (Platform.isWindows) {
        // Has to be called on init
        await setupTunnel();
      }
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> _initWireguardKey() async {
    try {
      await _generateWireguardKey();
    } catch (e) {
      _logger.handle(e);
    }
  }

  @action
  Future<bool> _checkTunelConfigured() async {
    try {
      return await _wireguardService.checkTunnelConfiguration(
        bundleId: _env.getBundleId(),
        tunnelName: _env.values.tunnelName,
      );
    } catch (e) {
      return false;
    }
  }

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocation = null;
    _connectionStatus = await _wireguardService.status();

    if (_connectionStatus == ConnectionStatus.connected) {
      final location = _sharedPrefs.getLocation() ?? _selectLocation();
      _connectingLocation = location;
      try {
        _resolveConnectionLocationFuture = ObservableFuture(
          _checkConnectionQuality(
            checkLocation: () => _resolveIPAddress(location),
            location: location!,
            hash: _vpnConfig?.hash ?? '',
          ),
        );
        await _resolveConnectionLocationFuture;
      } catch (e) {
        await disconnectWireguard();
      }
    } else {
      final originIP = await _apiService.getIPAdress();
      if (originIP != null) {
        this.originIP = originIP;
      }
    }

    _wireguardService.statusStream().listen((event) async {
      if (event == ConnectionStatus.disconnecting) {
        _vpnConnection = null;
      }
      _connectionStatus = event;
    });
  }

  /// Setup Wireguard tunnel
  @action
  Future<void> setupTunnel() async {
    try {
      await _wireguardService.setupTunnel(
        bundleId: _env.getBundleId(),
        win32ServiceName: win32ServiceName,
        tunnelName: _env.values.tunnelName,
      );
      _logger.info('Tunnel setup done');
      await _setupAndListenToConnectionStatus();
    } catch (e, stackTrace) {
      var message = 'Error occured while setting up tunnel';
      if (e is PlatformException) {
        if ((e.message?.contains('Permissions are not given') ?? false) ||
            (e.message?.contains('permission denied') ?? false)) {
          message = 'You need to grant permission to start VPN tunnel.';
        }
      }
      _logger.handle(e, stackTrace);
      showSnackbar(message);
      rethrow;
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
    final value = !_notSafeContentBlocker;
    if (value) {
      await _localDBService.setMalwareBlocker(malwareBlocker: value);
      _malwareBlockerContent = value;
    }
    await _localDBService.setNotSafeContentBlocker(notSafeContentBlocker: value);
    _notSafeContentBlocker = value;
  }

  @action
  Future<KeyPair> _generateWireguardKey() async {
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
    required String vpnConfig,
  }) async {
    // TODO(Waldz): Move to separate function, which mutates variable
    var config = vpnConfig;
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
    final status = await _wireguardService.status();
    if (status == ConnectionStatus.connected) {
      await _wireguardService.disconnect();
    }

    if (_connectionSub != null) {
      _connectionSub!.cancel();
    }
  }

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({
    VPNLocation? location,
    bool isRetrying = false,
  }) async {
    if (_connectionStatus == ConnectionStatus.connected &&
        (location == null || location == _vpnConnection?.location)) {
      await disconnectWireguard();
      _connectingLocation = null;
      return;
    }

    await _startConnection(location: location, isRetrying: isRetrying);
  }

  /// Connect to VPN by refreshing IP address
  @action
  Future<void> startConnectionWithRefreshIP() async {
    await _startConnection(refreshIP: true);
  }

  /// Connect to VPN
  @action
  Future<void> _startConnection({
    VPNLocation? location,
    bool? refreshIP,
    bool isRetrying = false,
  }) async {
    final subscription = await _subscriptionStore.subscriptionFuture;
    if (!subscription.active) {
      throw const SubscriptionRequiredException();
    }

    if (!(await _wireguardService.checkTunnelConfiguration(
      bundleId: _env.getBundleId(),
      tunnelName: _env.values.tunnelName,
    ))) {
      if (Platform.isWindows) {
        await setupTunnel();
      } else {
        throw const TunnelSetupRequiredException();
      }
    }

    location ??= refreshIP ?? false ? _vpnConnection?.location : _selectLocation();
    if (location == null) {
      return;
    }

    _connectingLocation = location;

    try {
      if (await _wireguardService.status() == ConnectionStatus.connected) {
        await disconnectWireguard();
        // Wait until connection is disconnected
        await Future.doWhile(() async {
          final tunnelStatus = await _wireguardService.status();
          if (tunnelStatus == ConnectionStatus.disconnected) {
            return false;
          }
          return true;
        });
      }

      await _completeConnection(location, refreshIP);

      _stopwatch.stop();
      if (_vpnConnection != null) {
        _analyticsStore.logConnectSuccess(
          location: _vpnConnection!.location,
          time: _stopwatch.elapsed,
          isRefresh: refreshIP,
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      _logger.handle(e);
      Sentry.captureException(e, stackTrace: stackTrace);

      showSnackbar(
        LocaleKeys.connectionTimeout.tr(),
      );

      _analyticsStore.logConnectFailure(
        time: _stopwatch.elapsed,
        error: e.message ?? e.toString(),
        errorType: e.runtimeType.toString(),
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
      final errorMessage = errorCode == 4029
          ? LocaleKeys.toManyRequestsErrorMsg.tr()
          : LocaleKeys.failedToConnectError.tr(
              namedArgs: {
                'errorCode': errorCode.toString(),
              },
            );
      if (_isRetrying == true) {
        return;
      }
      showSnackbar(errorMessage);
      _analyticsStore.logConnectFailure(
        time: _stopwatch.elapsed,
        error: e.toString(),
        errorType: e.runtimeType.toString(),
        errorCode: errorCode,
        errorMessage: errorMessage,
      );
    } finally {
      _stopwatch.stop();
    }
  }

  VPNLocation? _selectLocation() => _locationsStore.randomLocation();

  @action
  Future<void> _completeConnection(
    VPNLocation location,
    bool? refreshIP,
  ) async {
    try {
      final key = _wireguardKey ?? await _generateWireguardKey();
      _stopwatch
        ..reset()
        ..start();
      _fetchConfigFuture = ObservableFuture(
        _apiService.fetchVpnConfig(
          request: WireguardConnectRequest(
            publicKey: key.publicKey,
            country: location.code,
            ipType: switch (location.ipType) {
              IPType.datacenter => 'hosting',
              _ => null,
            },
            resetConnection: refreshIP ?? _refreshIPConnection,
            osType: Platform.operatingSystem,
          ),
        ),
      );
      _vpnConfig = await _fetchConfigFuture;

      await _connectWireguard(
        privateKey: key.privateKey,
        vpnConfig: _vpnConfig!.wgConfig,
      );

      _resolveConnectionLocationFuture = ObservableFuture(
        _checkConnectionQuality(
          checkLocation: () async {
            if (_vpnConfig?.exitIp != null) {
              _vpnConnection = _vpnConnection?.copyWith(connectionIP: _vpnConfig!.exitIp!);
              return;
            }
            _resolveIPAddress(location);
          },
          location: location,
          hash: _vpnConfig?.hash ?? '',
        ),
      );
      await _resolveConnectionLocationFuture!;
      if (_vpnConnection?.location != null) {
        _locationsStore.addRecentLocation(_vpnConnection!.location);
      }
      unawaited(_initMqtt());
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  Future<void> _initMqtt() async {
    try {
      await _mqtt.ensureStart();
      // TODO(Waldz): Make it mandatory, when backend field will be deployed
      final connectionID = _vpnConfig?.uid ?? '';
      _connectionSub ??= _mqtt.subscribe('mysterium-vpn/connection/$connectionID').listen((event) {
        final connection = _vpnConnection;
        if (connection == null) {
          return;
        }
        final connectionUpdate = ConnectionMessage.fromJson(
          json.decode(event) as Map<String, dynamic>,
        );
        _vpnConnection = connection.copyWith(
          connectionIP: connectionUpdate.location.ip,
          // TODO(dmacan): update with proper IPType once we receive it within ConnectionMessage
          location: connection.location.copyWith(
            code: connectionUpdate.location.country,
          ),
        );
      });
    } catch (e) {
      _logger.handle(e);
      // Do not throw error, until it's safe to do so
      //rethrow;
    }
  }

  Future<void> _checkConnectionQuality({
    required Future<void> Function() checkLocation,
    required VPNLocation location,
    required String hash,
  }) async {
    try {
      await _sharedPrefs.setLocation(location);
      _vpnConnection = VpnConnection(connectionIP: '', location: location);
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
              destinationCountry: location.code,
              osType: Platform.operatingSystem,
              appVersion: (await PackageInfo.fromPlatform()).version,
              originCountry: originIP?.country,
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

  Future<void> _resolveIPAddress(VPNLocation? location) async {
    var counter = 0;
    var resolvedIPAddress = '';
    await Future.doWhile(() async {
      counter++;
      await Future.delayed(const Duration(seconds: 3));
      final ipInfo = await _apiService.getIPAdress().timeout(
            const Duration(seconds: 10),
            onTimeout: () => null,
          );
      if (ipInfo != null && ipInfo.country == location?.code) {
        resolvedIPAddress = ipInfo.ip;
      }
      return counter < 5 && resolvedIPAddress.isEmpty;
    });

    if (resolvedIPAddress.isNotEmpty) {
      _vpnConnection = _vpnConnection?.copyWith(connectionIP: resolvedIPAddress);
    }
    // If IP address is not resolved, disconnect the connection
    else if ((_vpnConnection?.connectionIP.isEmpty ?? true) && _connectingLocation == location) {
      disconnectWireguard();
      _vpnConnection = null;
    }
  }

  @action
  Future<void> disconnectAllDevices() async {
    try {
      _disconnectAllDevicesFuture = ObservableFuture(
        _apiService.disconnectAllDevices(),
      );
      await disconnectWireguard();
      await _disconnectAllDevicesFuture;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  @action
  Future<void> resetApp() async {
    try {
      _resetAppFuture = ObservableFuture(
        _wireguardService.removeTunnelConfiguration(
          bundleId: _env.getBundleId(),
          tunnelName: _env.values.tunnelName,
        ),
      );
      await _resetAppFuture;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }
}
