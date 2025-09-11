// Flutter imports:
// Package imports:
// ignore_for_file: use_setters_to_change_properties

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/api/external_api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
import 'package:mysterium_vpn/services/wiregurad/wiregurad_key_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
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
    required ExternalApiService externalApiService,
    required MQTTService mqtt,
    required LocationsStore locationsStore,
    required WireguardDart wireguardService,
    required SubscriptionStore subscriptionStore,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required AuthSessionStore authSessionStore,
    required RealIPInfoStore realIPInfo,
    required WireguradKeyService wireguardKeyService,
  })  : _apiService = apiService,
        _externalApiService = externalApiService,
        _mqtt = mqtt,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _subscriptionStore = subscriptionStore,
        _analyticsStore = analyticsStore,
        _remoteConfigStore = remoteConfigStore,
        _authSessionStore = authSessionStore,
        _realIPInfo = realIPInfo,
        _logger = logger,
        _wireguardKeyService = wireguardKeyService {
    _init();
  }

  final ApiService _apiService;
  final ExternalApiService _externalApiService;
  final MQTTService _mqtt;
  final LocationsStore _locationsStore;
  final AnalyticsStore _analyticsStore;
  final WireguardDart _wireguardService;
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _realIPInfo;

  final WireguradKeyService _wireguardKeyService;
  final LocalDBService _localDBService = LocalDBService.instance;
  final Talker _logger;
  final Stopwatch _stopwatch = Stopwatch();
  StreamSubscription<String>? _connectionDataSub;
  StreamSubscription<String>? _connectionKilledSub;
  StreamSubscription<ConnectionStatus>? _wireguradConnectionStatus;

  @readonly
  bool _refreshIPConnection = true;

  @readonly
  bool _malwareBlockerContent = false;

  @observable
  bool connectionLimitReached = false;

  @readonly
  bool _notSafeContentBlocker = false;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  UserIntent? _userIntent;

  @readonly
  WireguardConnectResponse? _vpnConfig;

  @readonly
  KeyPair? _wireguardKey;

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  ConnectionStatus get vpnStatus => _connectionStatus == ConnectionStatus.unknown
      ? ConnectionStatus.disconnected
      : _connectionStatus;

  @observable
  RateConnectionRequestModeEnum? connectionRated;

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
      isFetchingConfig ||
      isFetchingLocation ||
      _connectionStatus == ConnectionStatus.disconnecting;

  @computed
  bool get isFetchingLocation => _fetchLocationFuture?.status == FutureStatus.pending;

  @computed
  bool get isFetchingConfig => _fetchConfigFuture?.status == FutureStatus.pending;

  @readonly
  VPNLocation? _connectingLocation;

  @computed
  VPNLocation? get location => _vpnConnection?.location ?? _connectingLocation;

  @computed
  VPNLocation? get potentialLocation => _locationsStore.randomLocation;

  @computed
  Set<UserIntent> get userIntents {
    final intents = {...UserIntent.values};
    final myCountry = _realIPInfo.info?.country;

    if (myCountry != null) {
      final availableCountries = {
        ...?_locationsStore.dcLocationsStream.value?.allLocations,
        ...?_locationsStore.residentialLocationsStream.value?.allLocations,
      };

      if (availableCountries.none((it) => it.countryCode == myCountry)) {
        intents.remove(UserIntent.nearestLocation);
      }
    } else {
      intents.remove(UserIntent.nearestLocation);
    }

    return intents;
  }

  @readonly
  ObservableFuture<void>? _resolveConnectionLocationFuture;

  @readonly
  ObservableFuture<VPNLocation?>? _fetchLocationFuture;

  @readonly
  ObservableFuture<WireguardConnectResponse>? _fetchConfigFuture;

  @readonly
  ObservableFuture<void>? _disconnectAllDevicesFuture;

  @readonly
  ObservableFuture<void>? _resetAppFuture;

  ReactionDisposer? _authReactionDisposer;
  ReactionDisposer? _selectedLocationReactionDisposer;

  @action
  Future<void> _init() async {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
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
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );

    _selectedLocationReactionDisposer = reaction<ConnectionStatus>(
      (_) => _connectionStatus,
      (status) {
        if (status == ConnectionStatus.connected || status == ConnectionStatus.connecting) {
          _locationsStore.selectedLocation = null;
        }
      },
    );
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _wireguradConnectionStatus?.cancel();
    _authReactionDisposer?.call();
    _selectedLocationReactionDisposer?.call();
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

  @action
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
      _wireguardKey = await _wireguardKeyService.getWireguradKey();
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> regenerateWireguradKey() async {
    try {
      await disconnectWireguard();
      _wireguardKey = await _wireguardKeyService.regenerateWireguardKeys();
    } catch (e) {
      _logger.handle(e);
    }
  }

  @action
  Future<bool> _checkTunelConfigured() async {
    try {
      return await _wireguardService.checkTunnelConfiguration(
        bundleId: Env.bundleId,
        tunnelName: Env.tunnelName,
      );
    } catch (e) {
      return false;
    }
  }

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocation = null;
    _setConnectionStatus(await checkTunnelStatus());

    await _locationsStore.recentLocationsFuture;
    if (_connectionStatus == ConnectionStatus.connected) {
      final location = potentialLocation;
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
    }
    final stream = _wireguardService.statusStream();
    _wireguradConnectionStatus = stream.listen((event) async {
      if (event == ConnectionStatus.disconnecting) {
        _vpnConnection = null;
        connectionRated = null;
      }
      _setConnectionStatus(event);
    });
  }

  @action
  void _setConnectionStatus(ConnectionStatus status) {
    _connectionStatus = status;
  }

  /// Setup Wireguard tunnel
  @action
  Future<void> setupTunnel() async {
    try {
      await _wireguardService.setupTunnel(
        bundleId: Env.bundleId,
        win32ServiceName: win32ServiceName,
        tunnelName: Env.tunnelName,
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
    await _localDBService.setNotSafeContentBlocker(
      notSafeContentBlocker: value,
    );
    _notSafeContentBlocker = value;
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
  Future<void> disconnectWireguard({bool isReconnecting = false}) async {
    final status = await checkTunnelStatus();
    if (status == ConnectionStatus.connected) {
      await _wireguardService.disconnect();
      if (!isReconnecting) {
        _userIntent = null;
        _connectingLocation = null;
        await notifyApiVpnDisconnected();
      }
    }

    if (_connectionDataSub != null) {
      _connectionDataSub!.cancel();
      _connectionDataSub = null;
    }
    if (_connectionKilledSub != null) {
      _connectionKilledSub?.cancel();
      _connectionKilledSub = null;
    }
  }

  /// Notify the API that the user has disconnected from the VPN tunnel.
  Future<void> notifyApiVpnDisconnected() async {
    try {
      if (_wireguardKey?.publicKey == null) {
        _logger.warning('Wireguard key is not initialized, cannot disconnect');
        return;
      }
      await _apiService.disconnect(
        publicKey: _wireguardKey!.publicKey,
      );
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
    }
  }

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying = false,
  }) async {
    if (_connectionStatus == ConnectionStatus.connected) {
      final connectedLocation = _vpnConnection?.location;
      final connectedIntent = _userIntent;
      await disconnectWireguard();
      if (location == null && intent == null) {
        return;
      }
      if (location != null && location == connectedLocation) {
        return;
      }
      if (intent != null && intent == connectedIntent) {
        return;
      }
    }

    await _startConnection(location: location, intent: intent, isRetrying: isRetrying);
  }

  /// Connect to VPN by refreshing IP address
  @action
  Future<void> startConnectionWithRefreshIP() async {
    await _startConnection(refreshIP: true, location: _vpnConnection?.location);
  }

  Future<void> _checkSubscriptionStatus() async {
    if (_subscriptionStore.subscriptionFuture.status == FutureStatus.pending) {
      return;
    }
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      if (!subscription.active) {
        throw const SubscriptionRequiredException();
      }
    } catch (e) {
      if (e is! SubscriptionRequiredException) {
        _subscriptionStore.refreshSubscription();
      }
      rethrow;
    }
  }

  /// Connect to VPN
  @action
  Future<void> _startConnection({
    VPNLocation? location,
    bool? refreshIP,
    bool isRetrying = false,
    UserIntent? intent,
  }) async {
    await _authSessionStore.accessTokenFuture;
    if (_authSessionStore.status != AuthStatus.authenticated) {
      throw AuthenticationRequiredException();
    }
    await _checkSubscriptionStatus();

    if (!(await _wireguardService.checkTunnelConfiguration(
      bundleId: Env.bundleId,
      tunnelName: Env.tunnelName,
    ))) {
      if (Platform.isWindows) {
        await setupTunnel();
      } else {
        throw const TunnelSetupRequiredException();
      }
    }

    _userIntent = intent;
    if (location != null) {
      _connectingLocation = location;
    } else if (refreshIP ?? false) {
      _connectingLocation = _vpnConnection?.location;
    } else if (_userIntent != null) {
      _connectingLocation = null;
    } else {
      _connectingLocation = potentialLocation;
    }

    if (_connectingLocation?.ipType == IPType.closest) {
      _fetchLocationFuture = ObservableFuture(_locationsStore.closestLocation(IPType.datacenter));
      final location = await _fetchLocationFuture;
      if (location != null) {
        _connectingLocation = location;
      }
    }
    if (_connectingLocation == null && _userIntent == null) {
      return;
    }

    try {
      if ((await checkTunnelStatus()) == ConnectionStatus.connected) {
        await disconnectWireguard(isReconnecting: true);
        // Wait until connection is disconnected
        await Future.doWhile(() async {
          final tunnelStatus = await checkTunnelStatus();
          if (tunnelStatus == ConnectionStatus.disconnected) {
            return false;
          }
          return true;
        });
      }

      await _completeConnection(_connectingLocation, _userIntent, refreshIP);

      _stopwatch.stop();
      if (_vpnConnection?.location != null) {
        _analyticsStore.logConnectSuccess(
          location: _vpnConnection!.location,
          time: _stopwatch.elapsed,
          isRefresh: refreshIP,
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      _userIntent = null;
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
      _userIntent = null;
      _logger.info('Operation cancelled by user');
    } catch (e, stackTrace) {
      _userIntent = null;
      _logger.handle(e, stackTrace);
      Sentry.captureException(e, stackTrace: stackTrace);

      final errorCode = e is WireguardConnectException
          ? e.code
          : e is ApiException
              ? e.code
              : 1113;
      final errorMessage = errorCode == 4029
          ? LocaleKeys.toManyRequestsErrorMsg.tr()
          : LocaleKeys.failedToConnectError.tr(
              namedArgs: {
                'errorCode': errorCode.toString(),
              },
            );

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

  @action
  Future<void> _completeConnection(
    VPNLocation? location,
    UserIntent? intent,
    bool? refreshIP,
  ) async {
    try {
      final key = _wireguardKey ?? await _wireguardKeyService.getWireguradKey();
      final closestRegion = (intent?.requiresCluster ?? false)
          ? await _locationsStore.closestRegion(location?.ipType ?? IPType.datacenter)
          : null;
      _stopwatch
        ..reset()
        ..start();
      final realIpInfo = await _realIPInfo.infoFuture;
      final ipType = location?.ipType ??
          (intent == UserIntent.nearestLocation ? _locationsStore.ipType : null);
      _fetchConfigFuture = ObservableFuture(
        _apiService.fetchVpnConfig(
          request: WireguardConnectRequest(
            publicKey: key.publicKey,
            countryOriginate: realIpInfo?.country,
            country:
                intent == UserIntent.nearestLocation ? realIpInfo?.country : location?.countryCode,
            city: intent == UserIntent.nearestLocation
                ? null
                : (location?.isCountry ?? true)
                    ? null
                    : location?.id,
            ipType: ipType?.key,
            resetConnection: refreshIP ?? _refreshIPConnection,
            osType: Platform.operatingSystem,
            userIntent: intent?.key,
            cluster: closestRegion?.id,
          ),
        ),
      );
      _vpnConfig = await _fetchConfigFuture;
      await _locationsStore.recentLocationsFuture;

      final locationId = _vpnConfig?.city ?? _vpnConfig?.country;
      VPNLocation? connectedLocation;
      if (locationId != null) {
        connectedLocation = _locationsStore.findLocation(
          locationId,
          countryCode: _vpnConfig?.country,
          ipType:
              _vpnConfig?.ipType == null ? IPType.datacenter : IPType.fromKey(_vpnConfig!.ipType!),
        );
      }
      connectedLocation ??= potentialLocation;

      if (connectedLocation == null) {
        throw Exception('Could not find connected location information');
      }

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
            await _resolveIPAddress(connectedLocation);
          },
          location: connectedLocation,
          hash: _vpnConfig?.hash ?? '',
        ),
      );
      await _resolveConnectionLocationFuture!;
      if (_vpnConnection?.location != null) {
        _locationsStore.addRecentLocation(_vpnConnection!.location);
      }
      unawaited(_subscribeConnectionChanges(_vpnConfig!.id));
      unawaited(_udpBlockedCheck());
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  Future<void> _subscribeConnectionChanges(String connectionID) async {
    try {
      _connectionDataSub =
          _mqtt.subscribe('mysterium-vpn/connection/$connectionID').listen((event) {
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
            id: connectionUpdate.location.country,
          ),
        );
        _analyticsStore.logEvent(
          AnalyticsEvent.ipChanged,
        );
      });

      _connectionKilledSub =
          _mqtt.subscribe('mysterium-vpn/connection/$connectionID/killed').listen((_) {
        connectionLimitReached = true;
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
      await _locationsStore.addRecentLocation(location);
      _vpnConnection = VpnConnection(connectionIP: '', location: location);
      await checkLocation();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _resolveIPAddress(VPNLocation? location) async {
    final ipAddress = await _externalApiService.getIPAddress();
    if (ipAddress != null && ipAddress.isNotEmpty) {
      _vpnConnection = _vpnConnection?.copyWith(connectionIP: ipAddress);
    } else if ((_vpnConnection?.connectionIP.isEmpty ?? true) && _connectingLocation == location) {
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
      if (!await _checkTunelConfigured()) {
        /// If tunnel is not configured, no need to reset the app
        return;
      }
      if (Platform.isAndroid) {
        return;
      } else if (Platform.isWindows) {
        _resetAppFuture = ObservableFuture(
          regenerateWireguradKey(),
        );
      } else {
        _resetAppFuture = ObservableFuture(
          _wireguardService.removeTunnelConfiguration(
            bundleId: Env.bundleId,
            tunnelName: Env.tunnelName,
          ),
        );
      }

      await _resetAppFuture;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  @action
  Future<void> _udpBlockedCheck() async {
    try {
      if (!_remoteConfigStore.shouldCheckUdp) {
        return;
      }
      await _apiService.udpBlockedCheck();
      _logger.info(
        'UDP block check completed in less than 2sec and it is not blocked',
      );
    } catch (e) {
      _analyticsStore.logEvent(
        AnalyticsEvent.udpBlocked,
        parameters: {
          'error': e.toString(),
        },
      );
    }
  }

  Future<ConnectionStatus> checkTunnelStatus() async {
    try {
      return await _wireguardService.status();
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
      return ConnectionStatus.unknown;
    }
  }
}
