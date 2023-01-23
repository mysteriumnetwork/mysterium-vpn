// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WireguardStore on _WireguardStore, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_WireguardStore.hasResults'))
          .value;

  late final _$setupTunelFutureAtom =
      Atom(name: '_WireguardStore.setupTunelFuture', context: context);

  @override
  ObservableFuture<void>? get setupTunelFuture {
    _$setupTunelFutureAtom.reportRead();
    return super.setupTunelFuture;
  }

  @override
  set setupTunelFuture(ObservableFuture<void>? value) {
    _$setupTunelFutureAtom.reportWrite(value, super.setupTunelFuture, () {
      super.setupTunelFuture = value;
    });
  }

  late final _$valueAtom =
      Atom(name: '_WireguardStore.value', context: context);

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$_WireguardStoreActionController =
      ActionController(name: '_WireguardStore', context: context);

  @override
  void increment() {
    final _$actionInfo = _$_WireguardStoreActionController.startAction(
        name: '_WireguardStore.increment');
    try {
      return super.increment();
    } finally {
      _$_WireguardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
setupTunelFuture: ${setupTunelFuture},
value: ${value},
hasResults: ${hasResults}
    ''';
  }
}
