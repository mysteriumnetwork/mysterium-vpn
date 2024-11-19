// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnStore on _VpnStore, Store {
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

  late final _$fetchConfigFutureAtom = Atom(name: '_VpnStore.fetchConfigFuture', context: context);

  @override
  ObservableFuture<VpnConfig>? get fetchConfigFuture {
    _$fetchConfigFutureAtom.reportRead();
    return super.fetchConfigFuture;
  }

  @override
  set fetchConfigFuture(ObservableFuture<VpnConfig>? value) {
    _$fetchConfigFutureAtom.reportWrite(value, super.fetchConfigFuture, () {
      super.fetchConfigFuture = value;
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

  late final _$_generateKeyAsyncAction = AsyncAction('_VpnStore._generateKey', context: context);

  @override
  Future<void> _generateKey() {
    return _$_generateKeyAsyncAction.run(() => super._generateKey());
  }

  late final _$_connectWireguardAsyncAction =
      AsyncAction('_VpnStore._connectWireguard', context: context);

  @override
  Future<void> _connectWireguard(String nonce) {
    return _$_connectWireguardAsyncAction.run(() => super._connectWireguard(nonce));
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
  Future<void> toggleConnection({String? location, bool? refreshIP, bool isRetrying = false}) {
    return _$toggleConnectionAsyncAction.run(() =>
        super.toggleConnection(location: location, refreshIP: refreshIP, isRetrying: isRetrying));
  }

  late final _$startConnectionAsyncAction =
      AsyncAction('_VpnStore.startConnection', context: context);

  @override
  Future<void> startConnection({String? location, bool? refreshIP, bool isRetrying = false}) {
    return _$startConnectionAsyncAction.run(() =>
        super.startConnection(location: location, refreshIP: refreshIP, isRetrying: isRetrying));
  }

  late final _$_completeConnectionAsyncAction =
      AsyncAction('_VpnStore._completeConnection', context: context);

  @override
  Future<VpnConnection> _completeConnection(String? location, bool? refreshIP, String nonce) {
    return _$_completeConnectionAsyncAction
        .run(() => super._completeConnection(location, refreshIP, nonce));
  }

  late final _$_VpnStoreActionController = ActionController(name: '_VpnStore', context: context);

  @override
  void _checkOperationCancel(String nonce) {
    final _$actionInfo =
        _$_VpnStoreActionController.startAction(name: '_VpnStore._checkOperationCancel');
    try {
      return super._checkOperationCancel(nonce);
    } finally {
      _$_VpnStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
resolveConnectionLocationFuture: ${resolveConnectionLocationFuture},
fetchConfigFuture: ${fetchConfigFuture},
replaceDNSAddress: ${replaceDNSAddress},
isConnected: ${isConnected},
isLoading: ${isLoading}
    ''';
  }
}
