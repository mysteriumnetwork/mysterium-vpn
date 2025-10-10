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
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
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
import 'package:mysterium_vpn/services/location/locations_service.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
import 'package:mysterium_vpn/services/wiregurad/openvpn_key_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_query_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:mysterium_vpn/stores/recent_locations_store.dart';
import 'package:mysterium_vpn/stores/refresh_ip_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/vpn/i_vpn.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:openvpn_dart/vpn_status.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

// Project imports:

part 'open_vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class OpenVpnStore = _OpenVpnStore with _$OpenVpnStore;

abstract class _OpenVpnStore extends IVpnStore with Store {
  _OpenVpnStore({
    required super.subscriptionStore,
    required super.authSessionStore,
    required ApiService apiService,
    required ExternalApiService externalApiService,
    required MQTTService mqtt,
    required LocationsStore locationsStore,
    required LocationsService locationsService,
    required OpenVPNDart openVpnService,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required RealIPInfoStore realIPInfo,
    required OpenVpnKeyService openVpnKeyService,
    required RefreshIPStore refreshIPStore,
    required RecentLocationsStore recentLocationsStore,
    required LocationsQueryStore locationsQueryStore,
  })  : _apiService = apiService,
        _externalApiService = externalApiService,
        _mqtt = mqtt,
        _locationsStore = locationsStore,
        _openVpnService = openVpnService,
        _analyticsStore = analyticsStore,
        _remoteConfigStore = remoteConfigStore,
        _authSessionStore = authSessionStore,
        _realIPInfo = realIPInfo,
        _logger = logger,
        _openVpnKeyService = openVpnKeyService,
        _refreshIPStore = refreshIPStore,
        _recentLocationsStore = recentLocationsStore,
        _locationsService = locationsService,
        _locationsQueryStore = locationsQueryStore {
    _init();
  }

  final ApiService _apiService;
  final ExternalApiService _externalApiService;
  final MQTTService _mqtt;
  final LocationsStore _locationsStore;
  final AnalyticsStore _analyticsStore;
  final OpenVPNDart _openVpnService;
  final RemoteConfigStore _remoteConfigStore;
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _realIPInfo;
  final RecentLocationsStore _recentLocationsStore;
  final LocationsQueryStore _locationsQueryStore;

  final LocationsService _locationsService;
  final OpenVpnKeyService _openVpnKeyService;
  final Talker _logger;
  final RefreshIPStore _refreshIPStore;
  final Stopwatch _stopwatch = Stopwatch();
  StreamSubscription<String>? _connectionDataSub;
  StreamSubscription<String>? _connectionKilledSub;
  StreamSubscription<VpnConnectionStatus>? _openVpnConnectionStatus;

  @override
  @observable
  bool connectionLimitReached = false;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  UserIntent? _userIntent;

  @readonly
  OpenVpnConnectResponse? _vpnConfig;

  // TODO(Kristijan): Remove/Create service for openvpn
  @readonly
  String? _openVpnKey;

  @readonly
  VpnConnectionStatus _connectionStatus = VpnConnectionStatus.disconnected;

  @override
  @computed
  VpnConnectionStatus get vpnStatus => _connectionStatus == VpnConnectionStatus.unknown
      ? VpnConnectionStatus.disconnected
      : _connectionStatus;

  @override
  @observable
  RateConnectionRequestModeEnum? connectionRated;

  @override
  @computed
  bool get isConnected =>
      _connectionStatus == VpnConnectionStatus.connected &&
      _fetchConfigFuture?.status != FutureStatus.pending;

  @override
  @computed
  bool get isLoading =>
      _connectionStatus == VpnConnectionStatus.connecting ||
      isFetchingConfig ||
      isFetchingLocation ||
      _connectionStatus == VpnConnectionStatus.disconnecting;

  @override
  @computed
  bool get isFetchingLocation => _fetchLocationFuture?.status == FutureStatus.pending;

  @override
  @computed
  bool get isFetchingConfig => _fetchConfigFuture?.status == FutureStatus.pending;

  @readonly
  VPNLocation? _connectingLocation;

  @override
  @computed
  VPNLocation? get location => _vpnConnection?.location ?? _connectingLocation;

  @override
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

    if (all.isEmpty) {
      return VPNLocation.closest;
    }

    return null;
  }

  @override
  @computed
  Set<UserIntent> get userIntents {
    final intents = {...UserIntent.values};
    final myCountry = _realIPInfo.info?.country;

    if (myCountry != null) {
      final availableCountries = {
        ...?_locationsStore.dcLocationsFuture.value?.allLocations,
        ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
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
  String? _publicKey;

  @override
  @computed
  bool get limitExceeded => _vpnConfig?.limitExceeded ?? false;

  @readonly
  ObservableFuture<void>? _resolveConnectionLocationFuture;

  @readonly
  ObservableFuture<VPNLocation?>? _fetchLocationFuture;

  @readonly
  ObservableFuture<OpenVpnConnectResponse>? _fetchConfigFuture;

  @readonly
  ObservableFuture<void>? _disconnectAllDevicesFuture;

  @readonly
  ObservableFuture<void>? _resetAppFuture;

  ReactionDisposer? _authReactionDisposer;

  @action
  Future<void> _init() async {
    await _openVpnService.initialize(
      providerBundleIdentifier: Env.openVpnExtensionBundleId,
      localizedDescription: Env.openVpnExtensionName,
    );
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
          await Future.wait<void>(
            [
              _initTunnel(),
              _initOpenVpndKey(),
            ],
          );
        }
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );
  }

  // Call on log out or app termiantion
  @override
  Future<void> disposeStore() async {
    _openVpnConnectionStatus?.cancel();
    _authReactionDisposer?.call();
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

  @action
  Future<void> _initOpenVpndKey() async {
    try {
      _openVpnKey = await _openVpnKeyService.getOpenVpnKey();
    } catch (e) {
      _logger.handle(e);
    }
  }

  @action
  Future<bool> _checkTunelConfigured() async {
    try {
      return await _openVpnService.checkTunnelConfiguration();
    } catch (e) {
      return false;
    }
  }

  /// Setup initial connection status and listen to connection status changes
  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocation = null;
    _setConnectionStatus(await checkTunnelStatus());

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
        await disconnectFromVpn();
      }
    }
    final stream = _openVpnService.statusStream();
    _openVpnConnectionStatus = stream.map(mapToVpnConnectionStatus).listen((status) async {
      if (status == VpnConnectionStatus.disconnecting) {
        _vpnConnection = null;
        connectionRated = null;
      }
      _setConnectionStatus(status);
    });
  }

  VpnConnectionStatus mapToVpnConnectionStatus(ConnectionStatus status) =>
      VpnConnectionStatus.fromString(status.name);

  @action
  void _setConnectionStatus(VpnConnectionStatus status) {
    _connectionStatus = status;
  }

  /// Setup OpenVPN tunnel
  @override
  @action
  Future<void> setupTunnel() async {
    try {
      await _openVpnService.setupTunnel();
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

  /// Connect to Wireguard tunnel
  @action
  Future<void> _connectOpenVpn({
    required String vpnConfig,
  }) async {
    try {
      await _openVpnService.connect(vpnConfig).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('OpenVPN connection timeout'),
          );
    } on TimeoutException catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      throw OpenVpnConnectException(e.toString());
    }
  }

  /// Disconnect from OpenVPN tunnel
  @override
  @action
  Future<void> disconnectFromVpn({bool isReconnecting = false}) async {
    final status = await checkTunnelStatus();
    if (status == VpnConnectionStatus.connected) {
      await _openVpnService.disconnect();
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
      if (_publicKey == null) {
        _logger.warning('OpenVPN key is not initialized, cannot disconnect');
        return;
      }
      await _apiService.disconnect(
        publicKey: _publicKey!,
      );
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
    }
  }

  /// Connect/Disconnect from VPN
  @override
  @action
  Future<void> toggleConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying = false,
  }) async {
    if (_connectionStatus == VpnConnectionStatus.connected) {
      final connectedLocation = _vpnConnection?.location;
      final connectedIntent = _userIntent;
      await disconnectFromVpn();
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
  @override
  @action
  Future<void> startConnectionWithRefreshIP() async {
    await _startConnection(refreshIP: true, location: _vpnConnection?.location);
  }

  /// Connect to VPN
  @action
  Future<void> _startConnection({
    VPNLocation? location,
    bool? refreshIP,
    bool isRetrying = false,
    UserIntent? intent,
  }) async {
    await checkVpnGuards();

    if (!(await _openVpnService.checkTunnelConfiguration())) {
      throw const TunnelSetupRequiredException();
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
      _fetchLocationFuture = ObservableFuture(_locationsStore.findClosest(IPType.datacenter));
      final location = await _fetchLocationFuture;
      if (location != null) {
        _connectingLocation = location;
      }
    }
    if (_connectingLocation == null && _userIntent == null) {
      return;
    }

    try {
      if ((await checkTunnelStatus()) == VpnConnectionStatus.connected) {
        await disconnectFromVpn(isReconnecting: true);
        // Wait until connection is disconnected
        await Future.doWhile(() async {
          final tunnelStatus = await checkTunnelStatus();
          if (tunnelStatus == VpnConnectionStatus.disconnected) {
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

      final errorCode = e is OpenVpnConnectException
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
      final key = _openVpnKey ?? await _openVpnKeyService.getOpenVpnKey();
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
        _apiService.fetchOpenVpnConfig(
          request: OpenVpnConnectRequest(
            publicKey: key,
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
            osType: Platform.operatingSystem,
            userIntent: intent?.key,
            cluster: closestRegion?.id,
          ),
        ),
      );
      _vpnConfig = await _fetchConfigFuture;
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

      await _connectOpenVpn(
        vpnConfig: _vpnConfig!.ovpnConfig,
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
      disconnectFromVpn();
      _vpnConnection = null;
    }
  }

  @override
  @action
  Future<void> disconnectAllDevices() async {
    try {
      _disconnectAllDevicesFuture = ObservableFuture(
        _apiService.disconnectAllDevices(),
      );
      await disconnectFromVpn();
      await _disconnectAllDevicesFuture;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  @override
  @action
  Future<void> resetApp() async {
    try {
      if (!await _checkTunelConfigured()) {
        /// If tunnel is not configured, no need to reset the app
        return;
      }
      if (Platform.isAndroid || Platform.isIOS) {
        return;
      }

      _resetAppFuture = ObservableFuture(
        _openVpnService.removeTunnelConfiguration(),
      );

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

  @override
  Future<VpnConnectionStatus> checkTunnelStatus() async {
    try {
      final status = await _openVpnService.getVPNStatus();
      return VpnConnectionStatus.fromString(status.name);
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
      return VpnConnectionStatus.unknown;
    }
  }
}
