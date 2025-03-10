// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnStore on _VpnStore, Store {
  Computed<ConnectionStatus>? _$vpnStatusComputed;

  @override
  ConnectionStatus get vpnStatus => (_$vpnStatusComputed ??=
          Computed<ConnectionStatus>(() => super.vpnStatus, name: '_VpnStore.vpnStatus'))
      .value;
  Computed<String?>? _$replaceDNSAddressComputed;

  @override
  String? get replaceDNSAddress => (_$replaceDNSAddressComputed ??=
          Computed<String?>(() => super.replaceDNSAddress, name: '_VpnStore.replaceDNSAddress'))
      .value;
  Computed<bool>? _$isConnectedComputed;

  @override
  bool get isConnected => (_$isConnectedComputed ??=
          Computed<bool>(() => super.isConnected, name: '_VpnStore.isConnected'))
      .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading, name: '_VpnStore.isLoading'))
          .value;
  Computed<VPNLocation?>? _$locationComputed;

  @override
  VPNLocation? get location => (_$locationComputed ??=
          Computed<VPNLocation?>(() => super.location, name: '_VpnStore.location'))
      .value;

  late final _$_refreshIPConnectionAtom =
      Atom(name: '_VpnStore._refreshIPConnection', context: context);

  bool get refreshIPConnection {
    _$_refreshIPConnectionAtom.reportRead();
    return super._refreshIPConnection;
  }

  @override
  bool get _refreshIPConnection => refreshIPConnection;

  @override
  set _refreshIPConnection(bool value) {
    _$_refreshIPConnectionAtom.reportWrite(value, super._refreshIPConnection, () {
      super._refreshIPConnection = value;
    });
  }

  late final _$_malwareBlockerContentAtom =
      Atom(name: '_VpnStore._malwareBlockerContent', context: context);

  bool get malwareBlockerContent {
    _$_malwareBlockerContentAtom.reportRead();
    return super._malwareBlockerContent;
  }

  @override
  bool get _malwareBlockerContent => malwareBlockerContent;

  @override
  set _malwareBlockerContent(bool value) {
    _$_malwareBlockerContentAtom.reportWrite(value, super._malwareBlockerContent, () {
      super._malwareBlockerContent = value;
    });
  }

  late final _$_notSafeContentBlockerAtom =
      Atom(name: '_VpnStore._notSafeContentBlocker', context: context);

  bool get notSafeContentBlocker {
    _$_notSafeContentBlockerAtom.reportRead();
    return super._notSafeContentBlocker;
  }

  @override
  bool get _notSafeContentBlocker => notSafeContentBlocker;

  @override
  set _notSafeContentBlocker(bool value) {
    _$_notSafeContentBlockerAtom.reportWrite(value, super._notSafeContentBlocker, () {
      super._notSafeContentBlocker = value;
    });
  }

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

  WireguardConnectResponse? get vpnConfig {
    _$_vpnConfigAtom.reportRead();
    return super._vpnConfig;
  }

  @override
  WireguardConnectResponse? get _vpnConfig => vpnConfig;

  @override
  set _vpnConfig(WireguardConnectResponse? value) {
    _$_vpnConfigAtom.reportWrite(value, super._vpnConfig, () {
      super._vpnConfig = value;
    });
  }

  late final _$_connectionStatusAtom = Atom(name: '_VpnStore._connectionStatus', context: context);

  ConnectionStatus get connectionStatus {
    _$_connectionStatusAtom.reportRead();
    return super._connectionStatus;
  }

  @override
  ConnectionStatus get _connectionStatus => connectionStatus;

  @override
  set _connectionStatus(ConnectionStatus value) {
    _$_connectionStatusAtom.reportWrite(value, super._connectionStatus, () {
      super._connectionStatus = value;
    });
  }

  late final _$_connectingLocationAtom =
      Atom(name: '_VpnStore._connectingLocation', context: context);

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

  late final _$_resolveConnectionLocationFutureAtom =
      Atom(name: '_VpnStore._resolveConnectionLocationFuture', context: context);

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

  late final _$_fetchConfigFutureAtom =
      Atom(name: '_VpnStore._fetchConfigFuture', context: context);

  ObservableFuture<WireguardConnectResponse>? get fetchConfigFuture {
    _$_fetchConfigFutureAtom.reportRead();
    return super._fetchConfigFuture;
  }

  @override
  ObservableFuture<WireguardConnectResponse>? get _fetchConfigFuture => fetchConfigFuture;

  @override
  set _fetchConfigFuture(ObservableFuture<WireguardConnectResponse>? value) {
    _$_fetchConfigFutureAtom.reportWrite(value, super._fetchConfigFuture, () {
      super._fetchConfigFuture = value;
    });
  }

  late final _$_disconnectAllDevicesFutureAtom =
      Atom(name: '_VpnStore._disconnectAllDevicesFuture', context: context);

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

  late final _$originIPAtom = Atom(name: '_VpnStore.originIP', context: context);

  @override
  IPInfo? get originIP {
    _$originIPAtom.reportRead();
    return super.originIP;
  }

  @override
  set originIP(IPInfo? value) {
    _$originIPAtom.reportWrite(value, super.originIP, () {
      super.originIP = value;
    });
  }

  late final _$_checkTunelConfiguredAsyncAction =
      AsyncAction('_VpnStore._checkTunelConfigured', context: context);

  @override
  Future<bool> _checkTunelConfigured() {
    return _$_checkTunelConfiguredAsyncAction.run(() => super._checkTunelConfigured());
  }

  late final _$_setupAndListenToConnectionStatusAsyncAction =
      AsyncAction('_VpnStore._setupAndListenToConnectionStatus', context: context);

  @override
  Future<void> _setupAndListenToConnectionStatus() {
    return _$_setupAndListenToConnectionStatusAsyncAction
        .run(() => super._setupAndListenToConnectionStatus());
  }

  late final _$setupTunnelAsyncAction = AsyncAction('_VpnStore.setupTunnel', context: context);

  @override
  Future<void> setupTunnel() {
    return _$setupTunnelAsyncAction.run(() => super.setupTunnel());
  }

  late final _$toggleRefreshIPWhenConnectingAsyncAction =
      AsyncAction('_VpnStore.toggleRefreshIPWhenConnecting', context: context);

  @override
  Future<void> toggleRefreshIPWhenConnecting() {
    return _$toggleRefreshIPWhenConnectingAsyncAction
        .run(() => super.toggleRefreshIPWhenConnecting());
  }

  late final _$toggleMalwareBlockerAsyncAction =
      AsyncAction('_VpnStore.toggleMalwareBlocker', context: context);

  @override
  Future<void> toggleMalwareBlocker() {
    return _$toggleMalwareBlockerAsyncAction.run(() => super.toggleMalwareBlocker());
  }

  late final _$toggleNotSafeContentBlockerAsyncAction =
      AsyncAction('_VpnStore.toggleNotSafeContentBlocker', context: context);

  @override
  Future<void> toggleNotSafeContentBlocker() {
    return _$toggleNotSafeContentBlockerAsyncAction.run(() => super.toggleNotSafeContentBlocker());
  }

  late final _$_generateWireguardKeyAsyncAction =
      AsyncAction('_VpnStore._generateWireguardKey', context: context);

  @override
  Future<KeyPair> _generateWireguardKey() {
    return _$_generateWireguardKeyAsyncAction.run(() => super._generateWireguardKey());
  }

  late final _$_connectWireguardAsyncAction =
      AsyncAction('_VpnStore._connectWireguard', context: context);

  @override
  Future<void> _connectWireguard({required String privateKey, required String vpnConfig}) {
    return _$_connectWireguardAsyncAction
        .run(() => super._connectWireguard(privateKey: privateKey, vpnConfig: vpnConfig));
  }

  late final _$disconnectWireguardAsyncAction =
      AsyncAction('_VpnStore.disconnectWireguard', context: context);

  @override
  Future<void> disconnectWireguard() {
    return _$disconnectWireguardAsyncAction.run(() => super.disconnectWireguard());
  }

  late final _$toggleConnectionAsyncAction =
      AsyncAction('_VpnStore.toggleConnection', context: context);

  @override
  Future<void> toggleConnection({VPNLocation? location, bool isRetrying = false}) {
    return _$toggleConnectionAsyncAction
        .run(() => super.toggleConnection(location: location, isRetrying: isRetrying));
  }

  late final _$startConnectionWithRefreshIPAsyncAction =
      AsyncAction('_VpnStore.startConnectionWithRefreshIP', context: context);

  @override
  Future<void> startConnectionWithRefreshIP() {
    return _$startConnectionWithRefreshIPAsyncAction
        .run(() => super.startConnectionWithRefreshIP());
  }

  late final _$_startConnectionAsyncAction =
      AsyncAction('_VpnStore._startConnection', context: context);

  @override
  Future<void> _startConnection({VPNLocation? location, bool? refreshIP, bool isRetrying = false}) {
    return _$_startConnectionAsyncAction.run(() =>
        super._startConnection(location: location, refreshIP: refreshIP, isRetrying: isRetrying));
  }

  late final _$_completeConnectionAsyncAction =
      AsyncAction('_VpnStore._completeConnection', context: context);

  @override
  Future<void> _completeConnection(VPNLocation location, bool? refreshIP) {
    return _$_completeConnectionAsyncAction
        .run(() => super._completeConnection(location, refreshIP));
  }

  late final _$disconnectAllDevicesAsyncAction =
      AsyncAction('_VpnStore.disconnectAllDevices', context: context);

  @override
  Future<void> disconnectAllDevices() {
    return _$disconnectAllDevicesAsyncAction.run(() => super.disconnectAllDevices());
  }

  late final _$resetAppAsyncAction = AsyncAction('_VpnStore.resetApp', context: context);

  @override
  Future<void> resetApp() {
    return _$resetAppAsyncAction.run(() => super.resetApp());
  }

  @override
  String toString() {
    return '''
originIP: ${originIP},
vpnStatus: ${vpnStatus},
replaceDNSAddress: ${replaceDNSAddress},
isConnected: ${isConnected},
isLoading: ${isLoading},
location: ${location}
    ''';
  }
}
