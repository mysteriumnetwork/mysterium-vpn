// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latlng_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LatLngStore on _LatLngStore, Store {
  late final _$_countryCoordinatesFutureAtom =
      Atom(name: '_LatLngStore._countryCoordinatesFuture', context: context);

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
        value, __countryCoordinatesFutureIsInitialized ? super._countryCoordinatesFuture : null,
        () {
      super._countryCoordinatesFuture = value;
      __countryCoordinatesFutureIsInitialized = true;
    });
  }

  late final _$_cityCoordinatesFutureAtom =
      Atom(name: '_LatLngStore._cityCoordinatesFuture', context: context);

  ObservableFuture<Map<String, LatLng>> get cityCoordinatesFuture {
    _$_cityCoordinatesFutureAtom.reportRead();
    return super._cityCoordinatesFuture;
  }

  @override
  ObservableFuture<Map<String, LatLng>> get _cityCoordinatesFuture => cityCoordinatesFuture;

  bool __cityCoordinatesFutureIsInitialized = false;

  @override
  set _cityCoordinatesFuture(ObservableFuture<Map<String, LatLng>> value) {
    _$_cityCoordinatesFutureAtom.reportWrite(
        value, __cityCoordinatesFutureIsInitialized ? super._cityCoordinatesFuture : null, () {
      super._cityCoordinatesFuture = value;
      __cityCoordinatesFutureIsInitialized = true;
    });
  }

  late final _$refreshIfNeededAsyncAction =
      AsyncAction('_LatLngStore.refreshIfNeeded', context: context);

  @override
  Future<void> refreshIfNeeded(Iterable<String> locations) {
    return _$refreshIfNeededAsyncAction.run(() => super.refreshIfNeeded(locations));
  }

  late final _$_LatLngStoreActionController =
      ActionController(name: '_LatLngStore', context: context);

  @override
  LatLng? coordinatesFor(String locationId) {
    final _$actionInfo =
        _$_LatLngStoreActionController.startAction(name: '_LatLngStore.coordinatesFor');
    try {
      return super.coordinatesFor(locationId);
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
