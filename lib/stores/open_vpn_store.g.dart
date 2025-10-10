// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OpenVpnStore on _OpenVpnStore, Store {
  Computed<VpnConnectionStatus>? _$vpnStatusComputed;

  @override
  VpnConnectionStatus get vpnStatus => (_$vpnStatusComputed ??=
          Computed<VpnConnectionStatus>(() => super.vpnStatus, name: '_OpenVpnStore.vpnStatus'))
      .value;
  Computed<bool>? _$isConnectedComputed;

  @override
  bool get isConnected => (_$isConnectedComputed ??=
          Computed<bool>(() => super.isConnected, name: '_OpenVpnStore.isConnected'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_OpenVpnStore.isLoading'))
      .value;
  Computed<bool>? _$isFetchingLocationComputed;

  @override
  bool get isFetchingLocation => (_$isFetchingLocationComputed ??=
          Computed<bool>(() => super.isFetchingLocation, name: '_OpenVpnStore.isFetchingLocation'))
      .value;
  Computed<bool>? _$isFetchingConfigComputed;

  @override
  bool get isFetchingConfig => (_$isFetchingConfigComputed ??=
          Computed<bool>(() => super.isFetchingConfig, name: '_OpenVpnStore.isFetchingConfig'))
      .value;
  Computed<VPNLocation?>? _$locationComputed;

  @override
  VPNLocation? get location => (_$locationComputed ??=
          Computed<VPNLocation?>(() => super.location, name: '_OpenVpnStore.location'))
      .value;
  Computed<VPNLocation?>? _$potentialLocationComputed;

  @override
  VPNLocation? get potentialLocation =>
      (_$potentialLocationComputed ??= Computed<VPNLocation?>(() => super.potentialLocation,
              name: '_OpenVpnStore.potentialLocation'))
          .value;
  Computed<Set<UserIntent>>? _$userIntentsComputed;

  @override
  Set<UserIntent> get userIntents => (_$userIntentsComputed ??=
          Computed<Set<UserIntent>>(() => super.userIntents, name: '_OpenVpnStore.userIntents'))
      .value;
  Computed<bool>? _$limitExceededComputed;

  @override
  bool get limitExceeded => (_$limitExceededComputed ??=
          Computed<bool>(() => super.limitExceeded, name: '_OpenVpnStore.limitExceeded'))
      .value;

  late final _$connectionLimitReachedAtom =
      Atom(name: '_OpenVpnStore.connectionLimitReached', context: context);

  @override
  bool get connectionLimitReached {
    _$connectionLimitReachedAtom.reportRead();
    return super.connectionLimitReached;
  }

  @override
  set connectionLimitReached(bool value) {
    _$connectionLimitReachedAtom.reportWrite(value, super.connectionLimitReached, () {
      super.connectionLimitReached = value;
    });
  }

  late final _$_vpnConnectionAtom = Atom(name: '_OpenVpnStore._vpnConnection', context: context);

  VpnConnection? get vpnConnection {
    _$_vpnConnectionAtom.reportRead();
    return super._vpnConnection;
  }

  @override
  VpnConnection? get _vpnConnection => vpnConnection;

  @override
  set _vpnConnection(VpnConnection? value) {
    _$_vpnConnectionAtom.reportWrite(value, super._vpnConnection, () {
      super._vpnConnection = value;
    });
  }

  late final _$_userIntentAtom = Atom(name: '_OpenVpnStore._userIntent', context: context);

  UserIntent? get userIntent {
    _$_userIntentAtom.reportRead();
    return super._userIntent;
  }

  @override
  UserIntent? get _userIntent => userIntent;

  @override
  set _userIntent(UserIntent? value) {
    _$_userIntentAtom.reportWrite(value, super._userIntent, () {
      super._userIntent = value;
    });
  }

  late final _$_vpnConfigAtom = Atom(name: '_OpenVpnStore._vpnConfig', context: context);

  OpenVpnConnectResponse? get vpnConfig {
    _$_vpnConfigAtom.reportRead();
    return super._vpnConfig;
  }

  @override
  OpenVpnConnectResponse? get _vpnConfig => vpnConfig;

  @override
  set _vpnConfig(OpenVpnConnectResponse? value) {
    _$_vpnConfigAtom.reportWrite(value, super._vpnConfig, () {
      super._vpnConfig = value;
    });
  }

  late final _$_connectionStatusAtom =
      Atom(name: '_OpenVpnStore._connectionStatus', context: context);

  VpnConnectionStatus get connectionStatus {
    _$_connectionStatusAtom.reportRead();
    return super._connectionStatus;
  }

  @override
  VpnConnectionStatus get _connectionStatus => connectionStatus;

  @override
  set _connectionStatus(VpnConnectionStatus value) {
    _$_connectionStatusAtom.reportWrite(value, super._connectionStatus, () {
      super._connectionStatus = value;
    });
  }

  late final _$connectionRatedAtom = Atom(name: '_OpenVpnStore.connectionRated', context: context);

  @override
  RateConnectionRequestModeEnum? get connectionRated {
    _$connectionRatedAtom.reportRead();
    return super.connectionRated;
  }

  @override
  set connectionRated(RateConnectionRequestModeEnum? value) {
    _$connectionRatedAtom.reportWrite(value, super.connectionRated, () {
      super.connectionRated = value;
    });
  }

  late final _$_connectingLocationAtom =
      Atom(name: '_OpenVpnStore._connectingLocation', context: context);

  VPNLocation? get connectingLocation {
    _$_connectingLocationAtom.reportRead();
    return super._connectingLocation;
  }

  @override
  VPNLocation? get _connectingLocation => connectingLocation;

  @override
  set _connectingLocation(VPNLocation? value) {
    _$_connectingLocationAtom.reportWrite(value, super._connectingLocation, () {
      super._connectingLocation = value;
    });
  }

  late final _$_publicKeyAtom = Atom(name: '_OpenVpnStore._publicKey', context: context);

  String? get publicKey {
    _$_publicKeyAtom.reportRead();
    return super._publicKey;
  }

  @override
  String? get _publicKey => publicKey;

  @override
  set _publicKey(String? value) {
    _$_publicKeyAtom.reportWrite(value, super._publicKey, () {
      super._publicKey = value;
    });
  }

  late final _$_resolveConnectionLocationFutureAtom =
      Atom(name: '_OpenVpnStore._resolveConnectionLocationFuture', context: context);

  ObservableFuture<void>? get resolveConnectionLocationFuture {
    _$_resolveConnectionLocationFutureAtom.reportRead();
    return super._resolveConnectionLocationFuture;
  }

  @override
  ObservableFuture<void>? get _resolveConnectionLocationFuture => resolveConnectionLocationFuture;

  @override
  set _resolveConnectionLocationFuture(ObservableFuture<void>? value) {
    _$_resolveConnectionLocationFutureAtom
        .reportWrite(value, super._resolveConnectionLocationFuture, () {
      super._resolveConnectionLocationFuture = value;
    });
  }

  late final _$_fetchLocationFutureAtom =
      Atom(name: '_OpenVpnStore._fetchLocationFuture', context: context);

  ObservableFuture<VPNLocation?>? get fetchLocationFuture {
    _$_fetchLocationFutureAtom.reportRead();
    return super._fetchLocationFuture;
  }

  @override
  ObservableFuture<VPNLocation?>? get _fetchLocationFuture => fetchLocationFuture;

  @override
  set _fetchLocationFuture(ObservableFuture<VPNLocation?>? value) {
    _$_fetchLocationFutureAtom.reportWrite(value, super._fetchLocationFuture, () {
      super._fetchLocationFuture = value;
    });
  }

  late final _$_fetchConfigFutureAtom =
      Atom(name: '_OpenVpnStore._fetchConfigFuture', context: context);

  ObservableFuture<OpenVpnConnectResponse>? get fetchConfigFuture {
    _$_fetchConfigFutureAtom.reportRead();
    return super._fetchConfigFuture;
  }

  @override
  ObservableFuture<OpenVpnConnectResponse>? get _fetchConfigFuture => fetchConfigFuture;

  @override
  set _fetchConfigFuture(ObservableFuture<OpenVpnConnectResponse>? value) {
    _$_fetchConfigFutureAtom.reportWrite(value, super._fetchConfigFuture, () {
      super._fetchConfigFuture = value;
    });
  }

  late final _$_disconnectAllDevicesFutureAtom =
      Atom(name: '_OpenVpnStore._disconnectAllDevicesFuture', context: context);

  ObservableFuture<void>? get disconnectAllDevicesFuture {
    _$_disconnectAllDevicesFutureAtom.reportRead();
    return super._disconnectAllDevicesFuture;
  }

  @override
  ObservableFuture<void>? get _disconnectAllDevicesFuture => disconnectAllDevicesFuture;

  @override
  set _disconnectAllDevicesFuture(ObservableFuture<void>? value) {
    _$_disconnectAllDevicesFutureAtom.reportWrite(value, super._disconnectAllDevicesFuture, () {
      super._disconnectAllDevicesFuture = value;
    });
  }

  late final _$_resetAppFutureAtom = Atom(name: '_OpenVpnStore._resetAppFuture', context: context);

  ObservableFuture<void>? get resetAppFuture {
    _$_resetAppFutureAtom.reportRead();
    return super._resetAppFuture;
  }

  @override
  ObservableFuture<void>? get _resetAppFuture => resetAppFuture;

  @override
  set _resetAppFuture(ObservableFuture<void>? value) {
    _$_resetAppFutureAtom.reportWrite(value, super._resetAppFuture, () {
      super._resetAppFuture = value;
    });
  }

  late final _$_initAsyncAction = AsyncAction('_OpenVpnStore._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$_initTunnelAsyncAction = AsyncAction('_OpenVpnStore._initTunnel', context: context);

  @override
  Future<void> _initTunnel() {
    return _$_initTunnelAsyncAction.run(() => super._initTunnel());
  }

  late final _$_initOpenVpndKeyAsyncAction =
      AsyncAction('_OpenVpnStore._initOpenVpndKey', context: context);

  @override
  Future<void> _initOpenVpndKey() {
    return _$_initOpenVpndKeyAsyncAction.run(() => super._initOpenVpndKey());
  }

  late final _$_checkTunelConfiguredAsyncAction =
      AsyncAction('_OpenVpnStore._checkTunelConfigured', context: context);

  @override
  Future<bool> _checkTunelConfigured() {
    return _$_checkTunelConfiguredAsyncAction.run(() => super._checkTunelConfigured());
  }

  late final _$_setupAndListenToConnectionStatusAsyncAction =
      AsyncAction('_OpenVpnStore._setupAndListenToConnectionStatus', context: context);

  @override
  Future<void> _setupAndListenToConnectionStatus() {
    return _$_setupAndListenToConnectionStatusAsyncAction
        .run(() => super._setupAndListenToConnectionStatus());
  }

  late final _$_setConnectionStatusAsyncAction =
      AsyncAction('_OpenVpnStore._setConnectionStatus', context: context);

  @override
  Future<void> _setConnectionStatus(VpnConnectionStatus status) {
    return _$_setConnectionStatusAsyncAction.run(() => super._setConnectionStatus(status));
  }

  late final _$setupTunnelAsyncAction = AsyncAction('_OpenVpnStore.setupTunnel', context: context);

  @override
  Future<void> setupTunnel() {
    return _$setupTunnelAsyncAction.run(() => super.setupTunnel());
  }

  late final _$_connectOpenVpnAsyncAction =
      AsyncAction('_OpenVpnStore._connectOpenVpn', context: context);

  @override
  Future<void> _connectOpenVpn({required String vpnConfig}) {
    return _$_connectOpenVpnAsyncAction.run(() => super._connectOpenVpn(vpnConfig: vpnConfig));
  }

  late final _$disconnectFromVpnAsyncAction =
      AsyncAction('_OpenVpnStore.disconnectFromVpn', context: context);

  @override
  Future<void> disconnectFromVpn({bool isReconnecting = false}) {
    return _$disconnectFromVpnAsyncAction
        .run(() => super.disconnectFromVpn(isReconnecting: isReconnecting));
  }

  late final _$toggleConnectionAsyncAction =
      AsyncAction('_OpenVpnStore.toggleConnection', context: context);

  @override
  Future<void> toggleConnection(
      {VPNLocation? location, UserIntent? intent, bool isRetrying = false}) {
    return _$toggleConnectionAsyncAction.run(
        () => super.toggleConnection(location: location, intent: intent, isRetrying: isRetrying));
  }

  late final _$startConnectionWithRefreshIPAsyncAction =
      AsyncAction('_OpenVpnStore.startConnectionWithRefreshIP', context: context);

  @override
  Future<void> startConnectionWithRefreshIP() {
    return _$startConnectionWithRefreshIPAsyncAction
        .run(() => super.startConnectionWithRefreshIP());
  }

  late final _$_startConnectionAsyncAction =
      AsyncAction('_OpenVpnStore._startConnection', context: context);

  @override
  Future<void> _startConnection(
      {VPNLocation? location, bool? refreshIP, bool isRetrying = false, UserIntent? intent}) {
    return _$_startConnectionAsyncAction.run(() => super._startConnection(
        location: location, refreshIP: refreshIP, isRetrying: isRetrying, intent: intent));
  }

  late final _$_completeConnectionAsyncAction =
      AsyncAction('_OpenVpnStore._completeConnection', context: context);

  @override
  Future<void> _completeConnection(VPNLocation? location, UserIntent? intent, bool? refreshIP) {
    return _$_completeConnectionAsyncAction
        .run(() => super._completeConnection(location, intent, refreshIP));
  }

  late final _$_checkConnectionQualityAsyncAction =
      AsyncAction('_OpenVpnStore._checkConnectionQuality', context: context);

  @override
  Future<void> _checkConnectionQuality(
      {required Future<void> Function() checkLocation,
      required VPNLocation location,
      required String hash}) {
    return _$_checkConnectionQualityAsyncAction.run(() => super
        ._checkConnectionQuality(checkLocation: checkLocation, location: location, hash: hash));
  }

  late final _$disconnectAllDevicesAsyncAction =
      AsyncAction('_OpenVpnStore.disconnectAllDevices', context: context);

  @override
  Future<void> disconnectAllDevices() {
    return _$disconnectAllDevicesAsyncAction.run(() => super.disconnectAllDevices());
  }

  late final _$resetAppAsyncAction = AsyncAction('_OpenVpnStore.resetApp', context: context);

  @override
  Future<void> resetApp() {
    return _$resetAppAsyncAction.run(() => super.resetApp());
  }

  late final _$_udpBlockedCheckAsyncAction =
      AsyncAction('_OpenVpnStore._udpBlockedCheck', context: context);

  @override
  Future<void> _udpBlockedCheck() {
    return _$_udpBlockedCheckAsyncAction.run(() => super._udpBlockedCheck());
  }

  @override
  String toString() {
    return '''
connectionLimitReached: ${connectionLimitReached},
connectionRated: ${connectionRated},
vpnStatus: ${vpnStatus},
isConnected: ${isConnected},
isLoading: ${isLoading},
isFetchingLocation: ${isFetchingLocation},
isFetchingConfig: ${isFetchingConfig},
location: ${location},
potentialLocation: ${potentialLocation},
userIntents: ${userIntents},
limitExceeded: ${limitExceeded}
    ''';
  }
}
