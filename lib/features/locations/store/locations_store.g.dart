// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsStore on _LocationsStore, Store {
  Computed<ObservableFuture<VPNLocations>>? _$locationsFutureComputed;

  @override
  ObservableFuture<VPNLocations> get locationsFuture =>
      (_$locationsFutureComputed ??= Computed<ObservableFuture<VPNLocations>>(
        () => super.locationsFuture,
        name: '_LocationsStore.locationsFuture',
      )).value;
  Computed<Set<String>>? _$countryCodesComputed;

  @override
  Set<String> get countryCodes =>
      (_$countryCodesComputed ??= Computed<Set<String>>(
        () => super.countryCodes,
        name: '_LocationsStore.countryCodes',
      )).value;
  Computed<List<VPNLocation>>? _$locationsComputed;

  @override
  List<VPNLocation> get locations =>
      (_$locationsComputed ??= Computed<List<VPNLocation>>(
        () => super.locations,
        name: '_LocationsStore.locations',
      )).value;
  Computed<List<VPNLocation>>? _$topLocationsComputed;

  @override
  List<VPNLocation> get topLocations =>
      (_$topLocationsComputed ??= Computed<List<VPNLocation>>(
        () => super.topLocations,
        name: '_LocationsStore.topLocations',
      )).value;
  Computed<bool?>? _$isEmptyComputed;

  @override
  bool? get isEmpty => (_$isEmptyComputed ??= Computed<bool?>(
    () => super.isEmpty,
    name: '_LocationsStore.isEmpty',
  )).value;
  Computed<List<IPType>>? _$locationTypesComputed;

  @override
  List<IPType> get locationTypes =>
      (_$locationTypesComputed ??= Computed<List<IPType>>(
        () => super.locationTypes,
        name: '_LocationsStore.locationTypes',
      )).value;

  late final _$_dcLocationsFutureAtom = Atom(
    name: '_LocationsStore._dcLocationsFuture',
    context: context,
  );

  ObservableFuture<VPNLocations> get dcLocationsFuture {
    _$_dcLocationsFutureAtom.reportRead();
    return super._dcLocationsFuture;
  }

  @override
  ObservableFuture<VPNLocations> get _dcLocationsFuture => dcLocationsFuture;

  bool __dcLocationsFutureIsInitialized = false;

  @override
  set _dcLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$_dcLocationsFutureAtom.reportWrite(
      value,
      __dcLocationsFutureIsInitialized ? super._dcLocationsFuture : null,
      () {
        super._dcLocationsFuture = value;
        __dcLocationsFutureIsInitialized = true;
      },
    );
  }

  late final _$_residentialLocationsFutureAtom = Atom(
    name: '_LocationsStore._residentialLocationsFuture',
    context: context,
  );

  ObservableFuture<VPNLocations> get residentialLocationsFuture {
    _$_residentialLocationsFutureAtom.reportRead();
    return super._residentialLocationsFuture;
  }

  @override
  ObservableFuture<VPNLocations> get _residentialLocationsFuture =>
      residentialLocationsFuture;

  bool __residentialLocationsFutureIsInitialized = false;

  @override
  set _residentialLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$_residentialLocationsFutureAtom.reportWrite(
      value,
      __residentialLocationsFutureIsInitialized
          ? super._residentialLocationsFuture
          : null,
      () {
        super._residentialLocationsFuture = value;
        __residentialLocationsFutureIsInitialized = true;
      },
    );
  }

  late final _$_fetchAsyncAction = AsyncAction(
    '_LocationsStore._fetch',
    context: context,
  );

  @override
  Future<VPNLocations> _fetch(IPType ipType) {
    return _$_fetchAsyncAction.run(() => super._fetch(ipType));
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_LocationsStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh([IPType? ipType]) {
    return _$refreshAsyncAction.run(() => super.refresh(ipType));
  }

  late final _$clearAsyncAction = AsyncAction(
    '_LocationsStore.clear',
    context: context,
  );

  @override
  Future<void> clear() {
    return _$clearAsyncAction.run(() => super.clear());
  }

  late final _$_LocationsStoreActionController = ActionController(
    name: '_LocationsStore',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    final _$actionInfo = _$_LocationsStoreActionController.startAction(
      name: '_LocationsStore.refreshAll',
    );
    try {
      return super.refreshAll();
    } finally {
      _$_LocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void insertInvalidLocations() {
    final _$actionInfo = _$_LocationsStoreActionController.startAction(
      name: '_LocationsStore.insertInvalidLocations',
    );
    try {
      return super.insertInvalidLocations();
    } finally {
      _$_LocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
locationsFuture: ${locationsFuture},
countryCodes: ${countryCodes},
locations: ${locations},
topLocations: ${topLocations},
isEmpty: ${isEmpty},
locationTypes: ${locationTypes}
    ''';
  }
}
