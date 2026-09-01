// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnStore on _VpnStore, Store {
  Computed<VpnConnectionStatus>? _$vpnStatusComputed;

  @override
  VpnConnectionStatus get vpnStatus => (_$vpnStatusComputed ??= Computed<VpnConnectionStatus>(
    () => super.vpnStatus,
    name: '_VpnStore.vpnStatus',
  )).value;
  Computed<bool>? _$isConnectedComputed;

  @override
  bool get isConnected => (_$isConnectedComputed ??= Computed<bool>(
    () => super.isConnected,
    name: '_VpnStore.isConnected',
  )).value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_VpnStore.isLoading',
  )).value;
  Computed<bool>? _$isFetchingLocationComputed;

  @override
  bool get isFetchingLocation => (_$isFetchingLocationComputed ??= Computed<bool>(
    () => super.isFetchingLocation,
    name: '_VpnStore.isFetchingLocation',
  )).value;
  Computed<bool>? _$isFetchingConfigComputed;

  @override
  bool get isFetchingConfig => (_$isFetchingConfigComputed ??= Computed<bool>(
    () => super.isFetchingConfig,
    name: '_VpnStore.isFetchingConfig',
  )).value;
  Computed<VPNLocation?>? _$locationComputed;

  @override
  VPNLocation? get location => (_$locationComputed ??= Computed<VPNLocation?>(
    () => super.location,
    name: '_VpnStore.location',
  )).value;
  Computed<int>? _$connectedIpPoolCountComputed;

  @override
  int get connectedIpPoolCount => (_$connectedIpPoolCountComputed ??= Computed<int>(
    () => super.connectedIpPoolCount,
    name: '_VpnStore.connectedIpPoolCount',
  )).value;
  Computed<VPNLocation?>? _$potentialLocationComputed;

  @override
  VPNLocation? get potentialLocation => (_$potentialLocationComputed ??= Computed<VPNLocation?>(
    () => super.potentialLocation,
    name: '_VpnStore.potentialLocation',
  )).value;

  late final _$_vpnConnectionAtom = Atom(name: '_VpnStore._vpnConnection', context: context);

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

  late final _$_vpnConfigAtom = Atom(name: '_VpnStore._vpnConfig', context: context);

  VpnConfig? get vpnConfig {
    _$_vpnConfigAtom.reportRead();
    return super._vpnConfig;
  }

  @override
  VpnConfig? get _vpnConfig => vpnConfig;

  @override
  set _vpnConfig(VpnConfig? value) {
    _$_vpnConfigAtom.reportWrite(value, super._vpnConfig, () {
      super._vpnConfig = value;
    });
  }

  late final _$_connectionStatusAtom = Atom(name: '_VpnStore._connectionStatus', context: context);

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

  late final _$_connectedAtAtom = Atom(name: '_VpnStore._connectedAt', context: context);

  DateTime? get connectedAt {
    _$_connectedAtAtom.reportRead();
    return super._connectedAt;
  }

  @override
  DateTime? get _connectedAt => connectedAt;

  @override
  set _connectedAt(DateTime? value) {
    _$_connectedAtAtom.reportWrite(value, super._connectedAt, () {
      super._connectedAt = value;
    });
  }

  late final _$_disconnectReasonAtom = Atom(name: '_VpnStore._disconnectReason', context: context);

  VpnDisconnectReason get disconnectReason {
    _$_disconnectReasonAtom.reportRead();
    return super._disconnectReason;
  }

  @override
  VpnDisconnectReason get _disconnectReason => disconnectReason;

  @override
  set _disconnectReason(VpnDisconnectReason value) {
    _$_disconnectReasonAtom.reportWrite(value, super._disconnectReason, () {
      super._disconnectReason = value;
    });
  }

  late final _$_userConnectEpochAtom = Atom(name: '_VpnStore._userConnectEpoch', context: context);

  int get userConnectEpoch {
    _$_userConnectEpochAtom.reportRead();
    return super._userConnectEpoch;
  }

  @override
  int get _userConnectEpoch => userConnectEpoch;

  @override
  set _userConnectEpoch(int value) {
    _$_userConnectEpochAtom.reportWrite(value, super._userConnectEpoch, () {
      super._userConnectEpoch = value;
    });
  }

  late final _$_connectingLocationAtom = Atom(
    name: '_VpnStore._connectingLocation',
    context: context,
  );

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

  late final _$_requestedLocationAtom = Atom(
    name: '_VpnStore._requestedLocation',
    context: context,
  );

  VPNLocation? get requestedLocation {
    _$_requestedLocationAtom.reportRead();
    return super._requestedLocation;
  }

  @override
  VPNLocation? get _requestedLocation => requestedLocation;

  @override
  set _requestedLocation(VPNLocation? value) {
    _$_requestedLocationAtom.reportWrite(value, super._requestedLocation, () {
      super._requestedLocation = value;
    });
  }

  late final _$_resolveConnectionLocationFutureAtom = Atom(
    name: '_VpnStore._resolveConnectionLocationFuture',
    context: context,
  );

  ObservableFuture<void>? get resolveConnectionLocationFuture {
    _$_resolveConnectionLocationFutureAtom.reportRead();
    return super._resolveConnectionLocationFuture;
  }

  @override
  ObservableFuture<void>? get _resolveConnectionLocationFuture => resolveConnectionLocationFuture;

  @override
  set _resolveConnectionLocationFuture(ObservableFuture<void>? value) {
    _$_resolveConnectionLocationFutureAtom.reportWrite(
      value,
      super._resolveConnectionLocationFuture,
      () {
        super._resolveConnectionLocationFuture = value;
      },
    );
  }

  late final _$_fetchLocationFutureAtom = Atom(
    name: '_VpnStore._fetchLocationFuture',
    context: context,
  );

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

  late final _$_fetchConfigFutureAtom = Atom(
    name: '_VpnStore._fetchConfigFuture',
    context: context,
  );

  ObservableFuture<VpnConfig>? get fetchConfigFuture {
    _$_fetchConfigFutureAtom.reportRead();
    return super._fetchConfigFuture;
  }

  @override
  ObservableFuture<VpnConfig>? get _fetchConfigFuture => fetchConfigFuture;

  @override
  set _fetchConfigFuture(ObservableFuture<VpnConfig>? value) {
    _$_fetchConfigFutureAtom.reportWrite(value, super._fetchConfigFuture, () {
      super._fetchConfigFuture = value;
    });
  }

  late final _$_disconnectAllDevicesFutureAtom = Atom(
    name: '_VpnStore._disconnectAllDevicesFuture',
    context: context,
  );

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

  late final _$_resetAppFutureAtom = Atom(name: '_VpnStore._resetAppFuture', context: context);

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

  late final _$connectionRatedAtom = Atom(name: '_VpnStore.connectionRated', context: context);

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

  late final _$_isDeviceLimitErrorShownAtom = Atom(
    name: '_VpnStore._isDeviceLimitErrorShown',
    context: context,
  );

  @override
  bool get _isDeviceLimitErrorShown {
    _$_isDeviceLimitErrorShownAtom.reportRead();
    return super._isDeviceLimitErrorShown;
  }

  @override
  set _isDeviceLimitErrorShown(bool value) {
    _$_isDeviceLimitErrorShownAtom.reportWrite(value, super._isDeviceLimitErrorShown, () {
      super._isDeviceLimitErrorShown = value;
    });
  }

  late final _$_connectionErrorAtom = Atom(name: '_VpnStore._connectionError', context: context);

  VpnError? get connectionError {
    _$_connectionErrorAtom.reportRead();
    return super._connectionError;
  }

  @override
  VpnError? get _connectionError => connectionError;

  @override
  set _connectionError(VpnError? value) {
    _$_connectionErrorAtom.reportWrite(value, super._connectionError, () {
      super._connectionError = value;
    });
  }

  late final _$_initAsyncAction = AsyncAction('_VpnStore._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$_applyProtocolAsyncAction = AsyncAction(
    '_VpnStore._applyProtocol',
    context: context,
  );

  @override
  Future<void> _applyProtocol(
    ProtocolType protocol, {
    VpnDisconnectReason reason = VpnDisconnectReason.user,
  }) {
    return _$_applyProtocolAsyncAction.run(() => super._applyProtocol(protocol, reason: reason));
  }

  late final _$switchProtocolAndReconnectAsyncAction = AsyncAction(
    '_VpnStore.switchProtocolAndReconnect',
    context: context,
  );

  @override
  Future<bool> switchProtocolAndReconnect(ProtocolType protocol) {
    return _$switchProtocolAndReconnectAsyncAction.run(
      () => super.switchProtocolAndReconnect(protocol),
    );
  }

  late final _$_initTunnelAsyncAction = AsyncAction('_VpnStore._initTunnel', context: context);

  @override
  Future<void> _initTunnel() {
    return _$_initTunnelAsyncAction.run(() => super._initTunnel());
  }

  late final _$setupTunnelAsyncAction = AsyncAction('_VpnStore.setupTunnel', context: context);

  @override
  Future<void> setupTunnel() {
    return _$setupTunnelAsyncAction.run(() => super.setupTunnel());
  }

  late final _$_setupAndListenToConnectionStatusAsyncAction = AsyncAction(
    '_VpnStore._setupAndListenToConnectionStatus',
    context: context,
  );

  @override
  Future<void> _setupAndListenToConnectionStatus() {
    return _$_setupAndListenToConnectionStatusAsyncAction.run(
      () => super._setupAndListenToConnectionStatus(),
    );
  }

  late final _$manageConnectionAsyncAction = AsyncAction(
    '_VpnStore.manageConnection',
    context: context,
  );

  @override
  Future<void> manageConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying = false,
    bool refreshIP = false,
    String? targetIp,
  }) {
    return _$manageConnectionAsyncAction.run(
      () => super.manageConnection(
        location: location,
        intent: intent,
        isRetrying: isRetrying,
        refreshIP: refreshIP,
        targetIp: targetIp,
      ),
    );
  }

  late final _$_startConnectionAsyncAction = AsyncAction(
    '_VpnStore._startConnection',
    context: context,
  );

  @override
  Future<void> _startConnection({
    VPNLocation? location,
    bool refreshIP = false,
    bool isRetrying = false,
    UserIntent? intent,
    String? targetIp,
  }) {
    return _$_startConnectionAsyncAction.run(
      () => super._startConnection(
        location: location,
        refreshIP: refreshIP,
        isRetrying: isRetrying,
        intent: intent,
        targetIp: targetIp,
      ),
    );
  }

  late final _$_prepareConnectionAsyncAction = AsyncAction(
    '_VpnStore._prepareConnection',
    context: context,
  );

  @override
  Future<void> _prepareConnection(
    VPNLocation? location,
    UserIntent? intent,
    bool refreshIP,
    String? targetIp,
  ) {
    return _$_prepareConnectionAsyncAction.run(
      () => super._prepareConnection(location, intent, refreshIP, targetIp),
    );
  }

  late final _$_completeConnectionAsyncAction = AsyncAction(
    '_VpnStore._completeConnection',
    context: context,
  );

  @override
  Future<void> _completeConnection(
    VPNLocation? location,
    UserIntent? intent,
    bool refreshIP, {
    String? targetIp,
  }) {
    return _$_completeConnectionAsyncAction.run(
      () => super._completeConnection(location, intent, refreshIP, targetIp: targetIp),
    );
  }

  late final _$_connectTunnelAsyncAction = AsyncAction(
    '_VpnStore._connectTunnel',
    context: context,
  );

  @override
  Future<void> _connectTunnel({required String vpnConfig}) {
    return _$_connectTunnelAsyncAction.run(() => super._connectTunnel(vpnConfig: vpnConfig));
  }

  late final _$disconnectTunnelAsyncAction = AsyncAction(
    '_VpnStore.disconnectTunnel',
    context: context,
  );

  @override
  Future<void> disconnectTunnel({required VpnDisconnectReason reason}) {
    return _$disconnectTunnelAsyncAction.run(() => super.disconnectTunnel(reason: reason));
  }

  late final _$disconnectAllDevicesAsyncAction = AsyncAction(
    '_VpnStore.disconnectAllDevices',
    context: context,
  );

  @override
  Future<void> disconnectAllDevices() {
    return _$disconnectAllDevicesAsyncAction.run(() => super.disconnectAllDevices());
  }

  late final _$_udpBlockedCheckAsyncAction = AsyncAction(
    '_VpnStore._udpBlockedCheck',
    context: context,
  );

  @override
  Future<void> _udpBlockedCheck() {
    return _$_udpBlockedCheckAsyncAction.run(() => super._udpBlockedCheck());
  }

  late final _$resetAppAsyncAction = AsyncAction('_VpnStore.resetApp', context: context);

  @override
  Future<void> resetApp() {
    return _$resetAppAsyncAction.run(() => super.resetApp());
  }

  late final _$submitRateConnectionAsyncAction = AsyncAction(
    '_VpnStore.submitRateConnection',
    context: context,
  );

  @override
  Future<void> submitRateConnection({
    required RateConnectionRequestModeEnum mode,
    required String? reasons,
    required String? feedback,
  }) {
    return _$submitRateConnectionAsyncAction.run(
      () => super.submitRateConnection(mode: mode, reasons: reasons, feedback: feedback),
    );
  }

  late final _$_VpnStoreActionController = ActionController(name: '_VpnStore', context: context);

  @override
  void markDeviceLimitErrorAsShown() {
    final _$actionInfo = _$_VpnStoreActionController.startAction(
      name: '_VpnStore.markDeviceLimitErrorAsShown',
    );
    try {
      return super.markDeviceLimitErrorAsShown();
    } finally {
      _$_VpnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleConnectedChange(bool connected) {
    final _$actionInfo = _$_VpnStoreActionController.startAction(
      name: '_VpnStore._handleConnectedChange',
    );
    try {
      return super._handleConnectedChange(connected);
    } finally {
      _$_VpnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _emitConnectionError(VpnError error) {
    final _$actionInfo = _$_VpnStoreActionController.startAction(
      name: '_VpnStore._emitConnectionError',
    );
    try {
      return super._emitConnectionError(error);
    } finally {
      _$_VpnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void consumeConnectionError() {
    final _$actionInfo = _$_VpnStoreActionController.startAction(
      name: '_VpnStore.consumeConnectionError',
    );
    try {
      return super.consumeConnectionError();
    } finally {
      _$_VpnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
connectionRated: ${connectionRated},
vpnStatus: ${vpnStatus},
isConnected: ${isConnected},
isLoading: ${isLoading},
isFetchingLocation: ${isFetchingLocation},
isFetchingConfig: ${isFetchingConfig},
location: ${location},
connectedIpPoolCount: ${connectedIpPoolCount},
potentialLocation: ${potentialLocation}
    ''';
  }
}
