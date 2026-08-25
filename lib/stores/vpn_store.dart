import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/vpn_error.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore extends VpnGuard with Store {
  _VpnStore({
    required ExternalApiService externalApiService,
    required MQTTService mqtt,
    required LocationsStore locationsStore,
    required LocationsService locationsService,
    required super.subscriptionStore,
    required Talker logger,
    required AnalyticsStore analyticsStore,
    required RemoteConfigStore remoteConfigStore,
    required super.authSessionStore,
    required RealIPInfoStore realIPInfo,
    required DNSStore dnsStore,
    required RefreshIPStore refreshIPStore,
    required RecentLocationsStore recentLocationsStore,
    required LocationsQueryStore locationsQueryStore,
    required UnavailableLocationsStore unavailableLocationsStore,
    required UserIntentsStore userIntentsStore,
    required ConnectionsLimitStore connectionsLimitStore,
    required WireguardRepository wireguardRepository,
    required OpenVpnRepository openVpnRepository,
    required ConnectionDecisionStore connectionDecisionStore,
    required VpnProtocolStore protocolStore,
    required IpRefreshExhaustionStore ipRefreshExhaustionStore,
  }) : _externalApiService = externalApiService,
       _mqtt = mqtt,
       _locationsStore = locationsStore,
       _connectionsLimitStore = connectionsLimitStore,
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
       _protocolStore = protocolStore,
       _wireguardRepository = wireguardRepository,
       _openVpnRepository = openVpnRepository,
       _vpnRepository = protocolStore.protocol == ProtocolType.wireguard
           ? wireguardRepository
           : openVpnRepository,
       _connectionDecisionStore = connectionDecisionStore,
       _ipRefreshExhaustionStore = ipRefreshExhaustionStore {
    _init();
  }

  // Services & Repositories
  final ExternalApiService _externalApiService;
  final MQTTService _mqtt;
  VpnRepository _vpnRepository;
  final WireguardRepository _wireguardRepository;
  final OpenVpnRepository _openVpnRepository;
  final Talker _logger;

  // Stores
  final LocationsStore _locationsStore;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final AuthSessionStore _authSessionStore;
  final RealIPInfoStore _realIPInfo;
  final RecentLocationsStore _recentLocationsStore;
  final LocationsQueryStore _locationsQueryStore;
  final UnavailableLocationsStore _unavailableLocationsStore;
  final UserIntentsStore _userIntentsStore;
  final LocationsService _locationsService;
  final DNSStore _dnsStore;
  final RefreshIPStore _refreshIPStore;
  final ConnectionsLimitStore _connectionsLimitStore;
  final ConnectionDecisionStore _connectionDecisionStore;
  final VpnProtocolStore _protocolStore;
  final IpRefreshExhaustionStore _ipRefreshExhaustionStore;

  // State
  final Stopwatch _stopwatch = Stopwatch();
  final SharedPreferenceService _prefs = SharedPreferenceService.instance;
  StreamSubscription<String>? _connectionDataSub;
  StreamSubscription<String>? _connectionKilledSub;
  StreamSubscription<VpnConnectionStatus>? _connectionStatusStream;
  ReactionDisposer? _authReactionDisposer;
  ReactionDisposer? _protocolReactionDisposer;
  ReactionDisposer? _connectedAtReactionDisposer;

  @readonly
  VpnConnection? _vpnConnection;

  @readonly
  VpnConfig? _vpnConfig;

  @readonly
  VpnConnectionStatus _connectionStatus = VpnConnectionStatus.disconnected;

  /// When the current tunnel session reached the connected state. Persisted so
  /// a session that outlives an app restart keeps its original start time.
  /// Null while disconnected.
  @readonly
  DateTime? _connectedAt;

  /// True while an existing connection is being torn down and re-established
  /// (IP refresh or server switch). The transitional `disconnected` it emits is
  /// not a real session end, so the review prompt skips it.
  @readonly
  bool _isReconnecting = false;

  /// Increments each time a user-initiated connection reaches the connected
  /// state. Excludes IP refresh / automatic fallback reconnections. Observed
  /// by the residential-IP education trigger to detect a fresh connect.
  @readonly
  int _userConnectEpoch = 0;

  @readonly
  VPNLocation? _connectingLocation;

  /// Location the user explicitly requested (country or city), preserved across
  /// IP refresh so a country keeps rotating country-wide. In-memory only.
  @readonly
  VPNLocation? _requestedLocation;

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

  @observable
  RateConnectionRequestModeEnum? connectionRated;

  @observable
  bool _isDeviceLimitErrorShown = false;

  // Computed Properties
  @computed
  VpnConnectionStatus get vpnStatus => _connectionStatus == VpnConnectionStatus.unknown
      ? VpnConnectionStatus.disconnected
      : _connectionStatus;

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

  @computed
  VPNLocation? get location => _vpnConnection?.location ?? _connectingLocation;

  /// IP-pool count to show under the refresh icon while connected: the country
  /// total when connected via a country, the city count when via a city. Falls
  /// back to the resolved location's count when the requested one is unknown
  /// (e.g. a recent location without a node count).
  @computed
  int get connectedIpPoolCount => _requestedLocation?.nodeCount ?? location?.nodeCount ?? 0;

  @computed
  VPNLocation? get potentialLocation => _connectionDecisionStore.potentialLocation;

  bool get isDeviceLimitErrorShown => _isDeviceLimitErrorShown;

  @action
  void markDeviceLimitErrorAsShown() {
    _isDeviceLimitErrorShown = true;
  }

  // ==================== Initialization ====================

  @action
  Future<void> _init() async {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      _handleAuthStatusChange,
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );

    // Set up protocol change reaction
    _protocolReactionDisposer = reaction<ProtocolType>(
      (_) => _protocolStore.protocol,
      _handleProtocolChange,
    );

    _connectedAtReactionDisposer = reaction<bool>(
      (_) => _connectionStatus == VpnConnectionStatus.connected,
      _updateConnectedAt,
    );
  }

  @action
  void _updateConnectedAt(bool connected) {
    if (!connected) {
      _connectedAt = null;
      _prefs.remove(StorageKeys.connectedAt.name).ignore();
      return;
    }
    // A stamp persisted by a previous run means this session was already up
    // before launch — keep its original start time so the clock survives
    // restarts. In-run connects find no stamp (disconnect removes it).
    final storedMs = _prefs.getInt(StorageKeys.connectedAt.name);
    if (storedMs != null) {
      _connectedAt = DateTime.fromMillisecondsSinceEpoch(storedMs);
    } else {
      _connectedAt = DateTime.now();
      _prefs.setInt(StorageKeys.connectedAt.name, _connectedAt!.millisecondsSinceEpoch).ignore();
    }
  }

  @action
  Future<void> _handleProtocolChange(ProtocolType protocol) async {
    if ((protocol == ProtocolType.wireguard && _vpnRepository is WireguardRepository) ||
        (protocol == ProtocolType.openvpn && _vpnRepository is OpenVpnRepository)) {
      _logger.info('Protocol is already set to: ${protocol.name}, no change needed');
      return;
    }
    _logger.info('Protocol changed to: ${protocol.name}');

    // Update the repository based on the new protocol
    final newRepository = protocol == ProtocolType.wireguard
        ? _wireguardRepository
        : _openVpnRepository;

    // If currently connected, disconnect before switching
    if (isConnected || isLoading) {
      _logger.info('Disconnecting before protocol switch');
      await disconnectTunnel();
    }

    _vpnRepository = newRepository;

    // Reinitialize the new repository if authenticated
    _handleAuthStatusChange(_authSessionStore.status);
  }

  Future<void> _handleAuthStatusChange(AuthStatus status) async {
    if (status == AuthStatus.authenticated) {
      await _vpnRepository.init();
      await _initTunnel();
    }
  }

  @action
  Future<void> _initTunnel() async {
    try {
      final isConfigured = await _vpnRepository.isTunnelConfigured();
      if (isConfigured) {
        await _setupAndListenToConnectionStatus();
      } else if (Platform.isWindows) {
        await setupTunnel();
      }
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> disposeStore() async {
    await _connectionStatusStream?.cancel();
    _authReactionDisposer?.call();
    _protocolReactionDisposer?.call();
    _connectedAtReactionDisposer?.call();
  }

  // ==================== Tunnel Management ====================

  @action
  Future<void> setupTunnel() async {
    try {
      await _vpnRepository.setupTunnel();
      await _setupAndListenToConnectionStatus();
    } catch (e) {
      _handleTunnelSetupError(e);
      rethrow;
    }
  }

  void _handleTunnelSetupError(Object e) {
    final permissionDenied =
        e is PlatformException &&
        ((e.message ?? '').contains('Permissions are not given') ||
            (e.message ?? '').contains('permission denied'));

    _emitConnectionError(
      VpnError(
        permissionDenied ? VpnErrorType.tunnelPermissionRequired : VpnErrorType.tunnelSetupFailed,
      ),
    );
  }

  @action
  Future<void> _setupAndListenToConnectionStatus() async {
    _connectingLocation = null;
    final status = await _vpnRepository.currentStatus();
    // Tunnel down at launch — drop any stale connectedAt stamp left by a
    // previous run so a later connect doesn't restore it.
    if (status != VpnConnectionStatus.connected) {
      await _prefs.remove(StorageKeys.connectedAt.name);
    }
    _connectionStatus = status;

    await _recentLocationsStore.future;

    if (_connectionStatus == VpnConnectionStatus.connected) {
      await _resolveExistingConnection();
    }

    _listenToConnectionStatusChanges();
  }

  Future<void> _resolveExistingConnection() async {
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
      // Tunnel was already up when the app launched: seed the exhaustion store
      // so refresh-IP presses are tracked this session (no fresh connect fired).
      _ipRefreshExhaustionStore.onConnected(location);
    } catch (e) {
      await disconnectTunnel();
    }
  }

  void _listenToConnectionStatusChanges() {
    final stream = _vpnRepository.statusStream();
    _connectionStatusStream = stream.listen((status) async {
      // The stream can deliver a stale non-connected event while the tunnel is
      // already connected (race between the connect handshake and the status
      // stream). Poll the real status and short-circuit so we don't clobber
      // the connected state with a delayed transitional event.
      final checkStatus = await _vpnRepository.currentStatus();
      if (checkStatus == VpnConnectionStatus.connected) {
        _connectionStatus = checkStatus;
        return;
      }
      if (status == VpnConnectionStatus.disconnecting) {
        _clearConnectionData();
      }
      _connectionStatus = status;
    });
  }

  void _clearConnectionData() {
    _vpnConnection = null;
    connectionRated = null;
  }

  /// Byte counters from whichever protocol is active — `_vpnRepository` is
  /// swapped on protocol change, so no selection logic is duplicated here.
  Future<TunnelStats?> tunnelStatistics() => _vpnRepository.tunnelStatistics();

  Future<VpnConnectionStatus> checkTunnelStatus() async {
    try {
      return await _vpnRepository.currentStatus();
    } catch (e) {
      _logger.handle(e);
      Sentry.captureException(e);
      return VpnConnectionStatus.unknown;
    }
  }

  // ==================== Connection Management ====================

  @action
  Future<void> manageConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying = false,
    bool refreshIP = false,
    String? targetIp,
  }) async {
    final action = _connectionDecisionStore.determineToggleAction(
      currentStatus: _connectionStatus,
      currentLocation: _vpnConnection?.location,
      requestedLocation: location,
      requestedIntent: intent,
      isRefreshIP: refreshIP,
      requestedTargetIp: targetIp,
      currentIp: _vpnConnection?.connectionIP,
    );

    switch (action) {
      case ConnectionAction.disconnect:
        await disconnectTunnel();
        break;

      case ConnectionAction.connect:
      case ConnectionAction.reconnect:
        await _startConnection(
          location: location,
          intent: intent,
          isRetrying: isRetrying,
          refreshIP: refreshIP,
          targetIp: targetIp,
        );
        break;

      case ConnectionAction.refreshIP:
        await _startConnection(
          refreshIP: true,
          location: _requestedLocation ?? _vpnConnection?.location,
        );
        break;
    }
  }

  @action
  Future<void> _startConnection({
    VPNLocation? location,
    bool refreshIP = false,
    bool isRetrying = false,
    UserIntent? intent,
    String? targetIp,
  }) async {
    await _validateConnectionPrerequisites();
    await _prepareConnection(location, intent, refreshIP);

    if (_connectingLocation == null && _userIntentsStore.userIntent == null) {
      return;
    }

    try {
      await _ensureDisconnected();
      await _executeConnection(refreshIP, targetIp: targetIp);
      _logConnectionSuccess(refreshIP);
    } on TimeoutException catch (e, stackTrace) {
      _handleConnectionTimeout(e, stackTrace);
    } on OperationCancelledException {
      _handleOperationCancelled();
    } catch (e, stackTrace) {
      _handleConnectionError(e, stackTrace);
    } finally {
      _stopwatch.stop();
      _isReconnecting = false;
    }
  }

  Future<void> _validateConnectionPrerequisites() async {
    await checkVpnGuards();

    if (!(await _vpnRepository.isTunnelConfigured())) {
      if (Platform.isWindows) {
        await setupTunnel();
      } else {
        throw const TunnelSetupRequiredException();
      }
    }
  }

  @action
  Future<void> _prepareConnection(VPNLocation? location, UserIntent? intent, bool refreshIP) async {
    _userIntentsStore.userIntent = intent;

    if (!refreshIP) {
      _requestedLocation = location == VPNLocation.closest ? null : location;
    }

    _connectingLocation = _connectionDecisionStore.determineConnectingLocation(
      requestedLocation: location,
      currentLocation: _vpnConnection?.location,
      isRefreshIP: refreshIP,
      intent: intent,
    );

    if (_connectionDecisionStore.shouldResolveClosestLocation(_connectingLocation)) {
      await _resolveClosestLocation();
    }
  }

  Future<void> _resolveClosestLocation() async {
    _fetchLocationFuture = ObservableFuture(_locationsStore.findClosest(IPType.datacenter));
    final location = await _fetchLocationFuture;
    if (location != null) {
      _connectingLocation = location;
    }
  }

  Future<void> _ensureDisconnected() async {
    if (await checkTunnelStatus() == VpnConnectionStatus.connected) {
      _isReconnecting = true;
      await disconnectTunnel(isReconnecting: true);
      await _waitForDisconnection();
    }
  }

  Future<void> _waitForDisconnection() async {
    await Future.doWhile(() async {
      final status = await checkTunnelStatus();
      return status != VpnConnectionStatus.disconnected;
    });
  }

  Future<void> _executeConnection(bool refreshIP, {String? targetIp}) async {
    _stopwatch
      ..reset()
      ..start();

    await _completeConnection(
      _connectingLocation,
      _userIntentsStore.userIntent,
      refreshIP,
      targetIp: targetIp,
    );
  }

  void _logConnectionSuccess(bool refreshIP) {
    _stopwatch.stop();
    if (!refreshIP) {
      _userConnectEpoch++;
    }
    if (_vpnConnection?.location != null) {
      _analyticsStore.logConnectSuccess(
        location: _vpnConnection!.location,
        time: _stopwatch.elapsed,
        isRefresh: refreshIP,
        protocol: _protocolStore.protocol,
      );
      if (refreshIP) {
        _ipRefreshExhaustionStore.registerRefresh(connectedIpPoolCount);
      } else {
        _ipRefreshExhaustionStore.onConnected(_requestedLocation ?? _vpnConnection!.location);
      }
    }
  }

  // ==================== Error Handling ====================

  /// One-shot connection failure for the UI to translate + display. The UI
  /// consumes it (via [consumeConnectionError]) after showing. Kept
  /// translation-free here so presentation stays in the view layer.
  @readonly
  VpnError? _connectionError;

  @action
  // ignore: use_setters_to_change_properties
  void _emitConnectionError(VpnError error) => _connectionError = error;

  @action
  void consumeConnectionError() => _connectionError = null;

  // Stable, locale-independent analytics label for a connection failure
  // (translation happens in the UI, so we can't log the user-facing text here).
  String _connectFailureLabel(Object e, int errorCode) => switch (e) {
    TimeoutException() => 'connectionTimeout',
    UnavailableLocationException() => 'locationUnavailable',
    DeviceLimitReachedException() => 'deviceLimitReached',
    _ => _isTooManyRequests(errorCode) ? 'tooManyRequests' : 'failedToConnect($errorCode)',
  };

  // Matches ApiErrorsInterceptor: both the backend 4029 and HTTP 429 mean
  // "too many requests".
  bool _isTooManyRequests(int errorCode) => errorCode == 4029 || errorCode == 429;

  void _handleConnectionTimeout(TimeoutException e, StackTrace stackTrace) {
    _userIntentsStore.userIntent = null;
    _logger.handle(e);
    Sentry.captureException(e, stackTrace: stackTrace);
    final errorCode = _extractErrorCode(e);
    _emitConnectionError(const VpnError(VpnErrorType.connectionTimeout));

    _analyticsStore.logConnectFailure(
      time: _stopwatch.elapsed,
      error: e.message ?? e.toString(),
      errorType: e.runtimeType.toString(),
      errorCode: errorCode,
      errorMessage: _connectFailureLabel(e, errorCode),
      protocol: _protocolStore.protocol,
    );
  }

  void _handleOperationCancelled() {
    _userIntentsStore.userIntent = null;
    _logger.info('Operation cancelled by user');
  }

  void _handleConnectionError(Object e, StackTrace stackTrace) {
    _userIntentsStore.userIntent = null;
    _logger.handle(e, stackTrace);
    Sentry.captureException(e, stackTrace: stackTrace);

    final errorCode = _extractErrorCode(e);
    // Null for exceptions that surface their own UI (device-limit dialog,
    // location-availability toggle) — those are suppressed from the snackbar.
    final error = _buildConnectionError(e, errorCode);
    if (error != null) {
      _emitConnectionError(error);
    }

    _analyticsStore.logConnectFailure(
      time: _stopwatch.elapsed,
      error: e.toString(),
      errorType: e.runtimeType.toString(),
      errorCode: errorCode,
      errorMessage: _connectFailureLabel(e, errorCode),
      protocol: _protocolStore.protocol,
    );
  }

  int _extractErrorCode(Object e) => switch (e) {
    VpnConnectException(:final code) => code,
    ApiException(:final code) => code,
    TimeoutException() => 1112,
    _ => 1113,
  };

  // Builds the displayable error, or null for exceptions that surface their own
  // UI (device-limit dialog, location-availability toggle) and are suppressed
  // from the snackbar.
  VpnError? _buildConnectionError(Object e, int errorCode) => switch (e) {
    UnavailableLocationException() || DeviceLimitReachedException() => null,
    _ =>
      _isTooManyRequests(errorCode)
          ? const VpnError(VpnErrorType.tooManyRequests)
          : VpnError(VpnErrorType.failedToConnect, errorCode: errorCode),
  };

  // ==================== Connection Completion ====================

  @action
  Future<void> _completeConnection(
    VPNLocation? location,
    UserIntent? intent,
    bool refreshIP, {
    String? targetIp,
  }) async {
    try {
      _vpnConfig = await fetchVpnConfiguration(
        location: location,
        intent: intent,
        refreshIP: refreshIP,
        targetIp: targetIp,
      );
      await _recentLocationsStore.future;

      final connectedLocation = await _resolveConnectedLocation(location);
      await _connectToTunnel();
      await _finalizeConnection(connectedLocation);

      unawaited(_subscribeConnectionChanges(_vpnConfig!.id));
      unawaited(_udpBlockedCheck());
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  @visibleForTesting
  Future<VpnConfig> fetchVpnConfiguration({
    required VPNLocation? location,
    required UserIntent? intent,
    required bool refreshIP,
    String? targetIp,
  }) async {
    final request = ConnectionRequest(location: location, intent: intent);

    final closestRegion = request.requiresCluster
        ? await _locationsService.closestRegion(location?.ipType ?? IPType.datacenter)
        : null;

    final realIpInfo = await _realIPInfo.infoFuture;
    final ipType = request.ipType(_locationsQueryStore.ipType);

    // Reset error tracking when fetching new config
    _isDeviceLimitErrorShown = false;

    _fetchConfigFuture = ObservableFuture(
      _vpnRepository.fetchVpnConfig(
        countryOriginate: realIpInfo?.country,
        country: request.country(realIpInfo),
        city: request.city,
        ipType: ipType?.key,
        resetConnection: refreshIP || _refreshIPStore.refreshIPConnection,
        userIntent: intent?.key,
        cluster: closestRegion?.id,
        dnsAddress: _dnsStore.dnsAddress,
        targetIp: targetIp,
      ),
    );

    try {
      return await _fetchConfigFuture!;
    } on ApiException catch (e) {
      if (e.code == 2332 && location != null) {
        // A targeted (favorite IP) failure means that IP is gone, not the
        // whole country — leave the country lists untouched.
        if (targetIp == null) {
          _unavailableLocationsStore.toggleAvailability(
            VPNLocation(
              id: location.id,
              ipType: location.ipType,
              translations: location.translations,
              countryCode: location.countryCode,
              isAvailable: location.isAvailable,
            ),
            availability: false,
          );
        }
        throw UnavailableLocationException(location);
      }
      rethrow;
    }
  }

  Future<VPNLocation> _resolveConnectedLocation(VPNLocation? requestedLocation) async {
    final locationId = _vpnConfig?.city ?? _vpnConfig?.country;

    if (locationId != null) {
      final countryCode = _vpnConfig?.country;
      final ipType = _vpnConfig?.ipType == null
          ? IPType.datacenter
          : IPType.fromKey(_vpnConfig!.ipType!);

      final match = await _locationsStore.findById(
        locationId,
        countryCode: countryCode,
        ipType: ipType,
      );

      if (match != null) {
        return match;
      }

      return VPNLocation(
        id: locationId,
        ipType: ipType,
        translations: const {},
        countryCode: countryCode ?? locationId,
      );
    }

    return potentialLocation ?? (throw Exception('Could not find connected location information'));
  }

  Future<void> _connectToTunnel() async {
    await _connectTunnel(vpnConfig: _vpnConfig!.config);
  }

  @action
  Future<void> _connectTunnel({required String vpnConfig}) async {
    await _vpnRepository.connect(config: vpnConfig);
  }

  Future<void> _finalizeConnection(VPNLocation connectedLocation) async {
    _resolveConnectionLocationFuture = ObservableFuture(
      _checkConnectionQuality(
        checkLocation: () => _updateConnectionIP(connectedLocation),
        location: connectedLocation,
        hash: _vpnConfig?.hash ?? '',
      ),
    );

    await _resolveConnectionLocationFuture!;

    if (_vpnConnection?.location != null) {
      await _recentLocationsStore.add(_vpnConnection!.location);
    }
  }

  Future<void> _updateConnectionIP(VPNLocation connectedLocation) async {
    if (_vpnConfig?.exitIp != null) {
      _vpnConnection = _vpnConnection?.copyWith(connectionIP: _vpnConfig!.exitIp!);
      return;
    }
    await _resolveIPAddress(connectedLocation);
  }

  Future<void> _checkConnectionQuality({
    required Future<void> Function() checkLocation,
    required VPNLocation location,
    required String hash,
  }) async {
    await _recentLocationsStore.add(location);
    _vpnConnection = VpnConnection(connectionIP: '', location: location);
    await checkLocation();
  }

  Future<void> _resolveIPAddress(VPNLocation? location) async {
    final ipAddress = await _externalApiService.getIPAddress();

    if (ipAddress != null && ipAddress.isNotEmpty) {
      _vpnConnection = _vpnConnection?.copyWith(connectionIP: ipAddress);
    } else if ((_vpnConnection?.connectionIP.isEmpty ?? true) && _connectingLocation == location) {
      await disconnectTunnel();
      _vpnConnection = null;
    }
  }

  // ==================== Disconnection ====================

  @action
  Future<void> disconnectTunnel({bool isReconnecting = false}) async {
    final disconnectSucceeded = await _vpnRepository.disconnect();

    if (disconnectSucceeded && !isReconnecting) {
      _userIntentsStore.userIntent = null;
      _connectingLocation = null;
      _requestedLocation = null;
      _ipRefreshExhaustionStore.onDisconnected();
      await _vpnRepository.notifyApiVpnDisconnected();
    }

    _cancelSubscriptions();
  }

  void _cancelSubscriptions() {
    _connectionDataSub?.cancel();
    _connectionDataSub = null;

    _connectionKilledSub?.cancel();
    _connectionKilledSub = null;
  }

  @action
  Future<void> disconnectAllDevices() async {
    try {
      _disconnectAllDevicesFuture = ObservableFuture(_vpnRepository.disconnectAllDevices());
      await disconnectTunnel();
      await _disconnectAllDevicesFuture;
    } catch (e) {
      _logger.handle(e);
      rethrow;
    }
  }

  // ==================== MQTT & Monitoring ====================

  Future<void> _subscribeConnectionChanges(String connectionID) async {
    try {
      _connectionDataSub = _mqtt
          .subscribe('mysterium-vpn/connection/$connectionID')
          .listen(_handleConnectionUpdate);

      _connectionKilledSub = _mqtt
          .subscribe('mysterium-vpn/connection/$connectionID/killed')
          .listen(_handleConnectionKilled);
    } catch (e) {
      _logger.handle(e);
    }
  }

  void _handleConnectionUpdate(String event) {
    final connection = _vpnConnection;
    if (connection == null) {
      return;
    }

    final update = ConnectionMessage.fromJson(json.decode(event) as Map<String, dynamic>);

    _vpnConnection = connection.copyWith(
      connectionIP: update.location.ip,
      location: connection.location.copyWith(id: update.location.country),
    );

    _analyticsStore.logEvent(AnalyticsEvent.ipChanged);
  }

  void _handleConnectionKilled(String _) {
    _connectionsLimitStore.connectionLimitReached = true;
  }

  @action
  Future<void> _udpBlockedCheck() async {
    if (!_remoteConfigStore.shouldCheckUdp) {
      return;
    }

    try {
      await _vpnRepository.udpBlockedCheck();
    } catch (e) {
      _analyticsStore.logEvent(AnalyticsEvent.udpBlocked, parameters: {'error': e.toString()});
    }
  }

  // ==================== App Management ====================

  @action
  Future<void> resetApp() async {
    try {
      _resetAppFuture = ObservableFuture(_vpnRepository.resetApp());
      await _resetAppFuture;
    } catch (e) {
      rethrow;
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
