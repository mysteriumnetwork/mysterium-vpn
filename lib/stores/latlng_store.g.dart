// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latlng_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LatLngStore on _LatLngStore, Store {
  late final _$_countryCoordinatesFutureAtom = Atom(
    name: '_LatLngStore._countryCoordinatesFuture',
    context: context,
  );

  ObservableFuture<Map<String, LatLng>> get countryCoordinatesFuture {
    _$_countryCoordinatesFutureAtom.reportRead();
    return super._countryCoordinatesFuture;
  }

  @override
  ObservableFuture<Map<String, LatLng>> get _countryCoordinatesFuture => countryCoordinatesFuture;

  bool __countryCoordinatesFutureIsInitialized = false;

  @override
  set _countryCoordinatesFuture(ObservableFuture<Map<String, LatLng>> value) {
    _$_countryCoordinatesFutureAtom.reportWrite(
      value,
      __countryCoordinatesFutureIsInitialized ? super._countryCoordinatesFuture : null,
      () {
        super._countryCoordinatesFuture = value;
        __countryCoordinatesFutureIsInitialized = true;
      },
    );
  }

  late final _$_LatLngStoreActionController = ActionController(
    name: '_LatLngStore',
    context: context,
  );

  @override
  LatLng? coordinatesForCountry(String countryCode) {
    final _$actionInfo = _$_LatLngStoreActionController.startAction(
      name: '_LatLngStore.coordinatesForCountry',
    );
    try {
      return super.coordinatesForCountry(countryCode);
    } finally {
      _$_LatLngStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  LatLng? coordinatesForCity(VPNLocation location) {
    final _$actionInfo = _$_LatLngStoreActionController.startAction(
      name: '_LatLngStore.coordinatesForCity',
    );
    try {
      return super.coordinatesForCity(location);
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
