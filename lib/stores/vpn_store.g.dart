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

  late final _$setupTunnelFutureAtom = Atom(name: '_VpnStore.setupTunnelFuture', context: context);

  @override
  ObservableFuture<void> get setupTunnelFuture {
    _$setupTunnelFutureAtom.reportRead();
    return super.setupTunnelFuture;
  }

  @override
  set setupTunnelFuture(ObservableFuture<void> value) {
    _$setupTunnelFutureAtom.reportWrite(value, super.setupTunnelFuture, () {
      super.setupTunnelFuture = value;
    });
  }

  late final _$_durationAtom = Atom(name: '_VpnStore._duration', context: context);

  Duration? get duration {
    _$_durationAtom.reportRead();
    return super._duration;
  }

  @override
  Duration? get _duration => duration;

  @override
  set _duration(Duration? value) {
    _$_durationAtom.reportWrite(value, super._duration, () {
      super._duration = value;
    });
  }

  late final _$_uploadSpeedAtom = Atom(name: '_VpnStore._uploadSpeed', context: context);

  double? get uploadSpeed {
    _$_uploadSpeedAtom.reportRead();
    return super._uploadSpeed;
  }

  @override
  double? get _uploadSpeed => uploadSpeed;

  @override
  set _uploadSpeed(double? value) {
    _$_uploadSpeedAtom.reportWrite(value, super._uploadSpeed, () {
      super._uploadSpeed = value;
    });
  }

  late final _$_downloadSpeedAtom = Atom(name: '_VpnStore._downloadSpeed', context: context);

  double? get downloadSpeed {
    _$_downloadSpeedAtom.reportRead();
    return super._downloadSpeed;
  }

  @override
  double? get _downloadSpeed => downloadSpeed;

  @override
  set _downloadSpeed(double? value) {
    _$_downloadSpeedAtom.reportWrite(value, super._downloadSpeed, () {
      super._downloadSpeed = value;
    });
  }

  late final _$_protocolAtom = Atom(name: '_VpnStore._protocol', context: context);

  String get protocol {
    _$_protocolAtom.reportRead();
    return super._protocol;
  }

  @override
  String get _protocol => protocol;

  @override
  set _protocol(String value) {
    _$_protocolAtom.reportWrite(value, super._protocol, () {
      super._protocol = value;
    });
  }

  late final _$_killSwitchAtom = Atom(name: '_VpnStore._killSwitch', context: context);

  bool get killSwitch {
    _$_killSwitchAtom.reportRead();
    return super._killSwitch;
  }

  @override
  bool get _killSwitch => killSwitch;

  @override
  set _killSwitch(bool value) {
    _$_killSwitchAtom.reportWrite(value, super._killSwitch, () {
      super._killSwitch = value;
    });
  }

  late final _$_vpnConnectionAtom = Atom(name: '_VpnStore._vpnConnection', context: context);

  VpnConnection get vpnConnection {
    _$_vpnConnectionAtom.reportRead();
    return super._vpnConnection;
  }

  @override
  VpnConnection get _vpnConnection => vpnConnection;

  @override
  set _vpnConnection(VpnConnection value) {
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

  late final _$setupTunnelAsyncAction = AsyncAction('_VpnStore.setupTunnel', context: context);

  @override
  Future<void> setupTunnel() {
    return _$setupTunnelAsyncAction.run(() => super.setupTunnel());
  }

  late final _$generateKeyAsyncAction = AsyncAction('_VpnStore.generateKey', context: context);

  @override
  Future<void> generateKey() {
    return _$generateKeyAsyncAction.run(() => super.generateKey());
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
  Future<void> connect({Location? location}) {
    return _$connectAsyncAction.run(() => super.connect(location: location));
  }

  late final _$changeProtocolAsyncAction =
      AsyncAction('_VpnStore.changeProtocol', context: context);

  @override
  Future<void> changeProtocol(String protocol) {
    return _$changeProtocolAsyncAction.run(() => super.changeProtocol(protocol));
  }

  late final _$toggleKillSwitchAsyncAction =
      AsyncAction('_VpnStore.toggleKillSwitch', context: context);

  @override
  Future<void> toggleKillSwitch() {
    return _$toggleKillSwitchAsyncAction.run(() => super.toggleKillSwitch());
  }

  late final _$startTrackingAsyncAction = AsyncAction('_VpnStore.startTracking', context: context);

  @override
  Future<void> startTracking() {
    return _$startTrackingAsyncAction.run(() => super.startTracking());
  }

  late final _$disconnectAsyncAction = AsyncAction('_VpnStore.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  @override
  String toString() {
    return '''
setupTunnelFuture: ${setupTunnelFuture},
isConnected: ${isConnected},
isLoading: ${isLoading}
    ''';
  }
}
