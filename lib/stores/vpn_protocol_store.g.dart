// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_protocol_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VpnProtocolStore on _VpnProtocolStore, Store {
  late final _$protocolFutureAtom =
      Atom(name: '_VpnProtocolStore.protocolFuture', context: context);

  @override
  ObservableFuture<ProtocolType> get protocolFuture {
    _$protocolFutureAtom.reportRead();
    return super.protocolFuture;
  }

  bool _protocolFutureIsInitialized = false;

  @override
  set protocolFuture(ObservableFuture<ProtocolType> value) {
    _$protocolFutureAtom
        .reportWrite(value, _protocolFutureIsInitialized ? super.protocolFuture : null, () {
      super.protocolFuture = value;
      _protocolFutureIsInitialized = true;
    });
  }

  late final _$protocolAtom = Atom(name: '_VpnProtocolStore.protocol', context: context);

  @override
  ProtocolType get protocol {
    _$protocolAtom.reportRead();
    return super.protocol;
  }

  @override
  set protocol(ProtocolType value) {
    _$protocolAtom.reportWrite(value, super.protocol, () {
      super.protocol = value;
    });
  }

  late final _$getProtocolAsyncAction =
      AsyncAction('_VpnProtocolStore.getProtocol', context: context);

  @override
  Future<ProtocolType> getProtocol() {
    return _$getProtocolAsyncAction.run(() => super.getProtocol());
  }

  late final _$setProtocolAsyncAction =
      AsyncAction('_VpnProtocolStore.setProtocol', context: context);

  @override
  Future<void> setProtocol(ProtocolType newProtocol) {
    return _$setProtocolAsyncAction.run(() => super.setProtocol(newProtocol));
  }

  @override
  String toString() {
    return '''
protocolFuture: ${protocolFuture},
protocol: ${protocol}
    ''';
  }
}
