// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latlng_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LatLngStore on _LatLngStore, Store {
  late final _$_coordinatesFutureAtom =
      Atom(name: '_LatLngStore._coordinatesFuture', context: context);

  ObservableFuture<Map<String, LatLng>> get coordinatesFuture {
    _$_coordinatesFutureAtom.reportRead();
    return super._coordinatesFuture;
  }

  @override
  ObservableFuture<Map<String, LatLng>> get _coordinatesFuture => coordinatesFuture;

  bool __coordinatesFutureIsInitialized = false;

  @override
  set _coordinatesFuture(ObservableFuture<Map<String, LatLng>> value) {
    _$_coordinatesFutureAtom
        .reportWrite(value, __coordinatesFutureIsInitialized ? super._coordinatesFuture : null, () {
      super._coordinatesFuture = value;
      __coordinatesFutureIsInitialized = true;
    });
  }

  late final _$_LatLngStoreActionController =
      ActionController(name: '_LatLngStore', context: context);

  @override
  LatLng? coordinatesFor(String countryCode) {
    final _$actionInfo =
        _$_LatLngStoreActionController.startAction(name: '_LatLngStore.coordinatesFor');
    try {
      return super.coordinatesFor(countryCode);
    } finally {
      _$_LatLngStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
