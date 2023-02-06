// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnStore on _VpnStore, Store {
  Computed<String?>? _$countryFlagComputed;

  @override
  String? get countryFlag => (_$countryFlagComputed ??=
          Computed<String?>(() => super.countryFlag, name: '_VpnStore.countryFlag'))
      .value;
  Computed<bool>? _$isConnectedComputed;

  @override
  bool get isConnected => (_$isConnectedComputed ??=
          Computed<bool>(() => super.isConnected, name: '_VpnStore.isConnected'))
      .value;

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

  late final _$connectAsyncAction = AsyncAction('_VpnStore.connect', context: context);

  @override
  Future<void> connect() {
    return _$connectAsyncAction.run(() => super.connect());
  }

  late final _$disconnectAsyncAction = AsyncAction('_VpnStore.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  @override
  String toString() {
    return '''
countryFlag: ${countryFlag},
isConnected: ${isConnected}
    ''';
  }
}
