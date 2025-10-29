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
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/unavailable_location_exception.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/api/external_api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/location/locations_service.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/connections_limit_store.dart';
import 'package:mysterium_vpn/stores/dns_store.dart';
import 'package:mysterium_vpn/stores/locations_query_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/recent_locations_store.dart';
import 'package:mysterium_vpn/stores/refresh_ip_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/unavailable_locations_store.dart';
import 'package:mysterium_vpn/stores/user_intents_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

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
    required LocationsService locationsService,
    required SubscriptionStore subscriptionStore,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required AuthSessionStore authSessionStore,
    required RealIPInfoStore realIPInfo,
    required DNSStore dnsStore,
    required RefreshIPStore refreshIPStore,
    required RecentLocationsStore recentLocationsStore,
    required LocationsQueryStore locationsQueryStore,
    required UnavailableLocationsStore unavailableLocationsStore,
    required UserIntentsStore userIntentsStore,
    required ConnectionsLimitStore connectionsLimitStore,
    required VpnRepository vpnRepository,
  })  : _apiService = apiService,
        _externalApiService = externalApiService,
        _mqtt = mqtt,
        _locationsStore = locationsStore,
        _connectionsLimitStore = connectionsLimitStore,
        _subscriptionStore = subscriptionStore,
        _analyticsStore = analyticsStore,
        _remoteConfigStore = remoteConfigStore,
        _authSessionStore = authSessionStore,
        _realIPInfo = realIPInfo,
        _logger = logger,
        _dnsStore = dnsStore,
        _refreshIPStore = refreshIPStore,
        _recentLocationsStore = recentLocationsStore,
        _locationsService = locationsService,
        _locationsQueryStore = locationsQueryStore,
        _unavailableLocationsStore = unavailableLocationsStore,
        _userIntentsStore = userIntentsStore,
        _vpnRepository = vpnRepository {
    _init();
  }

  final ApiService _apiService;
  final ExternalApiService _externalApiService;
  final MQTTService _mqtt;
  final LocationsStore _locationsStore;
  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _realIPInfo;
  final RecentLocationsStore _recentLocationsStore;
  final LocationsQueryStore _locationsQueryStore;
  final UnavailableLocationsStore _unavailableLocationsStore;
  final UserIntentsStore _userIntentsStore;
  final LocationsService _locationsService;
  final Talker _logger;
  final DNSStore _dnsStore;
  final RefreshIPStore _refreshIPStore;
  final Stopwatch _stopwatch = Stopwatch();
  final ConnectionsLimitStore _connectionsLimitStore;
  StreamSubscription<String>? _connectionDataSub;
  StreamSubscription<String>? _connectionKilledSub;
  StreamSubscription<VpnConnectionStatus>? _wireguradConnectionStatus;
  final VpnRepository _vpnRepository;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  VpnConfig? _vpnConfig;

  @readonly
  VpnConnectionStatus _connectionStatus = VpnConnectionStatus.disconnected;

  @computed
  VpnConnectionStatus get vpnStatus => _connectionStatus == VpnConnectionStatus.unknown
      ? VpnConnectionStatus.disconnected
      : _connectionStatus;

  @observable
  RateConnectionRequestModeEnum? connectionRated;

  @computed
  bool get isConnected =>
      _connectionStatus == VpnConnectionStatus.connected &&
      _fetchConfigFuture?.status != FutureStatus.pending;

  @computed
  bool get isLoading =>
      _connectionStatus == VpnConnectionStatus.connecting ||
      isFetchingConfig ||
      isFetchingLocation ||
      _connectionStatus == VpnConnectionStatus.disconnecting;

  @computed
  bool get isFetchingLocation => _fetchLocationFuture?.status == FutureStatus.pending;

  @computed
  bool get isFetchingConfig => _fetchConfigFuture?.status == FutureStatus.pending;

  @readonly
  VPNLocation? _connectingLocation;

  @computed
  VPNLocation? get location => _vpnConnection?.location ?? _connectingLocation;

  @computed
  VPNLocation? get potentialLocation {
    final recent = _recentLocationsStore.future.value?.firstOrNull;
    if (recent != null) {
      return recent;
    }
    final all = [
      ...?_locationsStore.dcLocationsFuture.value?.allLocations,
      ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
    ];

    if (all.isNotEmpty) {
      return VPNLocation.closest;
    }

    return null;
  }

  @readonly
  ObservableFuture<void>? _resolveConnectionLocationFuture;

  @readonly
  ObservableFuture<VPNLocation?>? _fetchLocationFuture;

  @readonly
  ObservableFuture<VpnConfig>? _fetchConfigFuture;

  @readonly
  ObservableFuture<void>? _disconnectAllDevicesFuture;

  @readonly
  ObservableFuture<void>? _resetAppFuture;

  ReactionDisposer? _authReactionDisposer;

  @action
  Future<void> _init() async {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
          await Future.wait<void>(
            [
              _initTunnel(),
              _vpnRepository.init(),
            ],
          );
        }
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _wireguradConnectionStatus?.cancel();
    _authReactionDisposer?.call();
  }

  @action
  Future<void> _initTunnel() async {
    try {
      final isConfigured = await _vpnRepository.isTunnelConfigured();
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

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocation = null;
    _setConnectionStatus(await _vpnRepository.currentStatus());

    await _recentLocationsStore.future;
    if (_connectionStatus == VpnConnectionStatus.connected) {
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
    final stream = _vpnRepository.statusStream();
    _wireguradConnectionStatus = stream.listen((event) async {
      if (event == VpnConnectionStatus.disconnecting) {
        _vpnConnection = null;
        connectionRated = null;
      }
      _setConnectionStatus(event);
    });
  }

  @action
  void _setConnectionStatus(VpnConnectionStatus status) {
    _connectionStatus = status;
  }

  /// Setup Wireguard tunnel
  @action
  Future<void> setupTunnel() async {
    try {
      await _vpnRepository.setupTunnel();
      await _setupAndListenToConnectionStatus();
    } catch (e) {
      var message = 'Error occured while setting up tunnel';
      if (e is PlatformException) {
        if ((e.message?.contains('Permissions are not given') ?? false) ||
            (e.message?.contains('permission denied') ?? false)) {
          message = 'You need to grant permission to start VPN tunnel.';
        }
      }
      showSnackbar(message);
      rethrow;
    }
  }

  /// Connect to Wireguard tunnel
  @action
  Future<void> _connectWireguard({
    required String vpnConfig,
  }) async {
    final config = _dnsStore.replaceDNSAddress(vpnConfig);
    try {
      await _vpnRepository.connect(config: config).timeout(
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
    final disconnectSucceeded = await _vpnRepository.disconnectFromVpn();
    if (disconnectSucceeded) {
      if (!isReconnecting) {
        _userIntentsStore.userIntent = null;
        _connectingLocation = null;
        await _vpnRepository.notifyApiVpnDisconnected();
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

  /// Connect/Disconnect from VPN
  @action
  Future<void> toggleConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying = false,
  }) async {
    if (_connectionStatus == VpnConnectionStatus.connected) {
      final connectedLocation = _vpnConnection?.location;
      final connectedIntent = _userIntentsStore.userIntent;
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

    if (!(await _vpnRepository.isTunnelConfigured())) {
      if (Platform.isWindows) {
        await setupTunnel();
      } else {
        throw const TunnelSetupRequiredException();
      }
    }

    _userIntentsStore.userIntent = intent;
    if (location != null) {
      _connectingLocation = location;
    } else if (refreshIP ?? false) {
      _connectingLocation = _vpnConnection?.location;
    } else if (_userIntentsStore.userIntent != null) {
      _connectingLocation = null;
    } else {
      _connectingLocation = potentialLocation;
    }

    if (_connectingLocation?.ipType == IPType.closest) {
      _fetchLocationFuture = ObservableFuture(_locationsStore.findClosest(IPType.datacenter));
      final location = await _fetchLocationFuture;
      if (location != null) {
        _connectingLocation = location;
      }
    }
    if (_connectingLocation == null && _userIntentsStore.userIntent == null) {
      return;
    }

    try {
      if ((await checkTunnelStatus()) == VpnConnectionStatus.connected) {
        await disconnectWireguard(isReconnecting: true);
        // Wait until connection is disconnected
        await Future.doWhile(() async {
          final tunnelStatus = await checkTunnelStatus();
          if (tunnelStatus == VpnConnectionStatus.disconnected) {
            return false;
          }
          return true;
        });
      }

      await _completeConnection(_connectingLocation, _userIntentsStore.userIntent, refreshIP);

      _stopwatch.stop();
      if (_vpnConnection?.location != null) {
        _analyticsStore.logConnectSuccess(
          location: _vpnConnection!.location,
          time: _stopwatch.elapsed,
          isRefresh: refreshIP,
        );
      }
    } on TimeoutException catch (e, stackTrace) {
      _userIntentsStore.userIntent = null;
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
      _userIntentsStore.userIntent = null;
      _logger.info('Operation cancelled by user');
    } catch (e, stackTrace) {
      _userIntentsStore.userIntent = null;
      _logger.handle(e, stackTrace);
      Sentry.captureException(e, stackTrace: stackTrace);

      final errorCode = switch (e) {
        final WireguardConnectException e => e.code,
        final ApiException e => e.code,
        _ => 1113,
      };

      final errorMessage = switch (e) {
        final UnavailableLocationException _ => null,
        _ => errorCode == 4029
            ? LocaleKeys.toManyRequestsErrorMsg.tr()
            : LocaleKeys.failedToConnectError.tr(
                namedArgs: {
                  'errorCode': errorCode.toString(),
                },
              ),
      };

      if (errorMessage != null) {
        showSnackbar(errorMessage);
      }
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
      final closestRegion = (intent?.requiresCluster ?? false)
          ? await _locationsService.closestRegion(location?.ipType ?? IPType.datacenter)
          : null;
      _stopwatch
        ..reset()
        ..start();
      final realIpInfo = await _realIPInfo.infoFuture;
      final ipType = location?.ipType ??
          (intent == UserIntent.nearestLocation ? _locationsQueryStore.ipType : null);
      _fetchConfigFuture = ObservableFuture(
        _vpnRepository.fetchVpnConfig(
          countryOriginate: realIpInfo?.country,
          country:
              intent == UserIntent.nearestLocation ? realIpInfo?.country : location?.countryCode,
          city: intent == UserIntent.nearestLocation
              ? null
              : (location?.isCountry ?? true)
                  ? null
                  : location?.id,
          ipType: ipType?.key,
          resetConnection: refreshIP ?? _refreshIPStore.refreshIPConnection,
          userIntent: intent?.key,
          cluster: closestRegion?.id,
        ),
      );

      try {
        _vpnConfig = await _fetchConfigFuture;
      } on ApiException catch (e) {
        if (e.code == 2332 && location != null) {
          _unavailableLocationsStore.toggleAvailability(location, availability: false);
          throw UnavailableLocationException(location);
        }
        rethrow;
      }
      await _recentLocationsStore.future;

      final locationId = _vpnConfig?.city ?? _vpnConfig?.country;
      VPNLocation? connectedLocation;
      if (locationId != null) {
        final countryCode = _vpnConfig?.country;
        final ipType =
            _vpnConfig?.ipType == null ? IPType.datacenter : IPType.fromKey(_vpnConfig!.ipType!);

        final match = await _locationsStore.findById(
          locationId,
          countryCode: countryCode,
          ipType: ipType,
        );

        connectedLocation = match ??
            VPNLocation(
              id: locationId,
              ipType: ipType,
              translations: const {},
              countryCode: countryCode ?? locationId,
            );
      }
      connectedLocation ??= potentialLocation;

      if (connectedLocation == null) {
        throw Exception('Could not find connected location information');
      }

      await _connectWireguard(
        vpnConfig: _vpnConfig!.config,
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
        await _recentLocationsStore.add(_vpnConnection!.location);
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
        _connectionsLimitStore.connectionLimitReached = true;
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
      await _recentLocationsStore.add(location);
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
      _resetAppFuture = ObservableFuture(
        _vpnRepository.resetApp(),
      );

      await _resetAppFuture;
    } catch (e) {
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

  Future<VpnConnectionStatus> checkTunnelStatus() async {
    try {
      return await _vpnRepository.currentStatus();
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
      return VpnConnectionStatus.unknown;
    }
  }

  @action
  Future<void> submitRateConnection({
    required RateConnectionRequestModeEnum mode,
    required String? reasons,
    required String? feedback,
  }) async {
    assert(_vpnConnection != null, 'VPN connection must not be null');

    await _vpnRepository.rateConnection(
      mode: mode,
      reasons: reasons,
      feedback: feedback,
      country: _vpnConnection!.location.id,
      ipType: _vpnConnection!.location.ipType.name,
    );
    connectionRated = mode;
  }
}
