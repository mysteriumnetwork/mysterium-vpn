// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnStore on _VpnStore, Store {
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

  late final _$_requestedRefreshIPAtom =
      Atom(name: '_VpnStore._requestedRefreshIP', context: context);

  bool? get requestedRefreshIP {
    _$_requestedRefreshIPAtom.reportRead();
    return super._requestedRefreshIP;
  }

  @override
  bool? get _requestedRefreshIP => requestedRefreshIP;

  @override
  set _requestedRefreshIP(bool? value) {
    _$_requestedRefreshIPAtom.reportWrite(value, super._requestedRefreshIP, () {
      super._requestedRefreshIP = value;
    });
  }

  late final _$_vpnConfigConsentAtom = Atom(name: '_VpnStore._vpnConfigConsent', context: context);

  bool? get vpnConfigConsent {
    _$_vpnConfigConsentAtom.reportRead();
    return super._vpnConfigConsent;
  }

  @override
  bool? get _vpnConfigConsent => vpnConfigConsent;

  @override
  set _vpnConfigConsent(bool? value) {
    _$_vpnConfigConsentAtom.reportWrite(value, super._vpnConfigConsent, () {
      super._vpnConfigConsent = value;
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

  late final _$_connectingLocationCodeAtom =
      Atom(name: '_VpnStore._connectingLocationCode', context: context);

  String? get connectingLocationCode {
    _$_connectingLocationCodeAtom.reportRead();
    return super._connectingLocationCode;
  }

  @override
  String? get _connectingLocationCode => connectingLocationCode;

  @override
  set _connectingLocationCode(String? value) {
    _$_connectingLocationCodeAtom.reportWrite(value, super._connectingLocationCode, () {
      super._connectingLocationCode = value;
    });
  }

  late final _$_isCanceledAtom = Atom(name: '_VpnStore._isCanceled', context: context);

  @override
  bool get _isCanceled {
    _$_isCanceledAtom.reportRead();
    return super._isCanceled;
  }

  @override
  set _isCanceled(bool value) {
    _$_isCanceledAtom.reportWrite(value, super._isCanceled, () {
      super._isCanceled = value;
    });
  }

  late final _$resolveConnectionLocationFutureAtom =
      Atom(name: '_VpnStore.resolveConnectionLocationFuture', context: context);

  @override
  ObservableFuture<VpnConnection>? get resolveConnectionLocationFuture {
    _$resolveConnectionLocationFutureAtom.reportRead();
    return super.resolveConnectionLocationFuture;
  }

  @override
  set resolveConnectionLocationFuture(ObservableFuture<VpnConnection>? value) {
    _$resolveConnectionLocationFutureAtom.reportWrite(value, super.resolveConnectionLocationFuture,
        () {
      super.resolveConnectionLocationFuture = value;
    });
  }

  late final _$_setupAndListenToConnectionStatusAsyncAction =
      AsyncAction('_VpnStore._setupAndListenToConnectionStatus', context: context);

  @override
  Future<void> _setupAndListenToConnectionStatus() {
    return _$_setupAndListenToConnectionStatusAsyncAction
        .run(() => super._setupAndListenToConnectionStatus());
  }

  late final _$_setupTunnelAsyncAction = AsyncAction('_VpnStore._setupTunnel', context: context);

  @override
  Future<void> _setupTunnel() {
    return _$_setupTunnelAsyncAction.run(() => super._setupTunnel());
  }

  late final _$setVpnConfigConsentAsyncAction =
      AsyncAction('_VpnStore.setVpnConfigConsent', context: context);

  @override
  Future<void> setVpnConfigConsent({required bool value}) {
    return _$setVpnConfigConsentAsyncAction.run(() => super.setVpnConfigConsent(value: value));
  }

  late final _$toggleRefreshIPWhenConnectingAsyncAction =
      AsyncAction('_VpnStore.toggleRefreshIPWhenConnecting', context: context);

  @override
  Future<void> toggleRefreshIPWhenConnecting() {
    return _$toggleRefreshIPWhenConnectingAsyncAction
        .run(() => super.toggleRefreshIPWhenConnecting());
  }

  late final _$_generateKeyAsyncAction = AsyncAction('_VpnStore._generateKey', context: context);

  @override
  Future<void> _generateKey() {
    return _$_generateKeyAsyncAction.run(() => super._generateKey());
  }

  late final _$_cancelConnectionAsyncAction =
      AsyncAction('_VpnStore._cancelConnection', context: context);

  @override
  Future<void> _cancelConnection() {
    return _$_cancelConnectionAsyncAction.run(() => super._cancelConnection());
  }

  late final _$_connectWireguardAsyncAction =
      AsyncAction('_VpnStore._connectWireguard', context: context);

  @override
  Future<void> _connectWireguard() {
    return _$_connectWireguardAsyncAction.run(() => super._connectWireguard());
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
  Future<void> toggleConnection({String? location, bool? refreshIP}) {
    return _$toggleConnectionAsyncAction
        .run(() => super.toggleConnection(location: location, refreshIP: refreshIP));
  }

  late final _$_completeConnectionAsyncAction =
      AsyncAction('_VpnStore._completeConnection', context: context);

  @override
  Future<VpnConnection> _completeConnection(
      String? location, Stopwatch stopwatch, bool? refreshIP) {
    return _$_completeConnectionAsyncAction
        .run(() => super._completeConnection(location, stopwatch, refreshIP));
  }

  @override
  String toString() {
    return '''
resolveConnectionLocationFuture: ${resolveConnectionLocationFuture},
isConnected: ${isConnected},
isLoading: ${isLoading}
    ''';
  }
}
