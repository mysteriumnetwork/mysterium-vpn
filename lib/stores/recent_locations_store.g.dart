// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecentLocationsStore on _RecentLocationsStore, Store {
  Computed<List<VPNLocation>>? _$valueComputed;

  @override
  List<VPNLocation> get value =>
      (_$valueComputed ??= Computed<List<VPNLocation>>(
        () => super.value,
        name: '_RecentLocationsStore.value',
      )).value;

  late final _$_futureAtom = Atom(
    name: '_RecentLocationsStore._future',
    context: context,
  );

  ObservableFuture<List<VPNLocation>> get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<List<VPNLocation>> get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(ObservableFuture<List<VPNLocation>> value) {
    _$_futureAtom.reportWrite(
      value,
      __futureIsInitialized ? super._future : null,
      () {
        super._future = value;
        __futureIsInitialized = true;
      },
    );
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
