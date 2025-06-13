// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_id_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeviceIDStore on _DeviceIDStore, Store {
  late final _$deviceIdFutureAtom = Atom(name: '_DeviceIDStore.deviceIdFuture', context: context);

  @override
  ObservableFuture<String> get deviceIdFuture {
    _$deviceIdFutureAtom.reportRead();
    return super.deviceIdFuture;
  }

  bool _deviceIdFutureIsInitialized = false;

  @override
  set deviceIdFuture(ObservableFuture<String> value) {
    _$deviceIdFutureAtom
        .reportWrite(value, _deviceIdFutureIsInitialized ? super.deviceIdFuture : null, () {
      super.deviceIdFuture = value;
      _deviceIdFutureIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
deviceIdFuture: ${deviceIdFuture}
    ''';
  }
}
