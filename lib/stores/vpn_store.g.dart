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

  late final _$_resetConnectionAtom = Atom(name: '_VpnStore._resetConnection', context: context);

  bool get resetConnection {
    _$_resetConnectionAtom.reportRead();
    return super._resetConnection;
  }

  @override
  bool get _resetConnection => resetConnection;

  @override
  set _resetConnection(bool value) {
    _$_resetConnectionAtom.reportWrite(value, super._resetConnection, () {
      super._resetConnection = value;
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

  late final _$_privateKeyAtom = Atom(name: '_VpnStore._privateKey', context: context);

  String get privateKey {
    _$_privateKeyAtom.reportRead();
    return super._privateKey;
  }

  @override
  String get _privateKey => privateKey;

  @override
  set _privateKey(String value) {
    _$_privateKeyAtom.reportWrite(value, super._privateKey, () {
      super._privateKey = value;
    });
  }

  late final _$_publicKeyAtom = Atom(name: '_VpnStore._publicKey', context: context);

  String get publicKey {
    _$_publicKeyAtom.reportRead();
    return super._publicKey;
  }

  @override
  String get _publicKey => publicKey;

  @override
  set _publicKey(String value) {
    _$_publicKeyAtom.reportWrite(value, super._publicKey, () {
      super._publicKey = value;
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

  late final _$setupTunnelAsyncAction = AsyncAction('_VpnStore.setupTunnel', context: context);

  @override
  Future<void> setupTunnel() {
    return _$setupTunnelAsyncAction.run(() => super.setupTunnel());
  }

  late final _$setVpnConfigConsentAsyncAction =
      AsyncAction('_VpnStore.setVpnConfigConsent', context: context);

  @override
  Future<void> setVpnConfigConsent({required bool value}) {
    return _$setVpnConfigConsentAsyncAction.run(() => super.setVpnConfigConsent(value: value));
  }

  late final _$toggleResetConnectionAsyncAction =
      AsyncAction('_VpnStore.toggleResetConnection', context: context);

  @override
  Future<void> toggleResetConnection() {
    return _$toggleResetConnectionAsyncAction.run(() => super.toggleResetConnection());
  }

  late final _$generateKeyAsyncAction = AsyncAction('_VpnStore.generateKey', context: context);

  @override
  Future<void> generateKey() {
    return _$generateKeyAsyncAction.run(() => super.generateKey());
  }

  late final _$cancelConnectionAsyncAction =
      AsyncAction('_VpnStore.cancelConnection', context: context);

  @override
  Future<void> cancelConnection() {
    return _$cancelConnectionAsyncAction.run(() => super.cancelConnection());
  }

  late final _$connectWireguardAsyncAction =
      AsyncAction('_VpnStore.connectWireguard', context: context);

  @override
  Future<void> connectWireguard() {
    return _$connectWireguardAsyncAction.run(() => super.connectWireguard());
  }

  late final _$disconnectWireguardAsyncAction =
      AsyncAction('_VpnStore.disconnectWireguard', context: context);

  @override
  Future<void> disconnectWireguard() {
    return _$disconnectWireguardAsyncAction.run(() => super.disconnectWireguard());
  }

  late final _$connectAsyncAction = AsyncAction('_VpnStore.connect', context: context);

  @override
  Future<void> connect({String? location, bool? refreshIP}) {
    return _$connectAsyncAction.run(() => super.connect(location: location, refreshIP: refreshIP));
  }

  late final _$_completeConnectionAsyncAction =
      AsyncAction('_VpnStore._completeConnection', context: context);

  @override
  Future<VpnConnection> _completeConnection(
      String? location, Stopwatch stopwatch, bool? refreshIP) {
    return _$_completeConnectionAsyncAction
        .run(() => super._completeConnection(location, stopwatch, refreshIP));
  }

  late final _$disconnectAsyncAction = AsyncAction('_VpnStore.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  @override
  String toString() {
    return '''
isConnected: ${isConnected},
isLoading: ${isLoading}
    ''';
  }
}
