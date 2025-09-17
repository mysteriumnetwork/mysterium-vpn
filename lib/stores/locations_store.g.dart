// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsStore on _LocationsStore, Store {
  Computed<ObservableFuture<VPNLocations>>? _$locationsFutureComputed;

  @override
  ObservableFuture<VPNLocations> get locationsFuture => (_$locationsFutureComputed ??=
          Computed<ObservableFuture<VPNLocations>>(() => super.locationsFuture,
              name: '_LocationsStore.locationsFuture'))
      .value;
  Computed<Set<String>>? _$availableCountriesComputed;

  @override
  Set<String> get availableCountries =>
      (_$availableCountriesComputed ??= Computed<Set<String>>(() => super.availableCountries,
              name: '_LocationsStore.availableCountries'))
          .value;
  Computed<List<VPNLocation>>? _$recentLocationsComputed;

  @override
  List<VPNLocation> get recentLocations =>
      (_$recentLocationsComputed ??= Computed<List<VPNLocation>>(() => super.recentLocations,
              name: '_LocationsStore.recentLocations'))
          .value;
  Computed<List<VPNLocation>>? _$locationsComputed;

  @override
  List<VPNLocation> get locations => (_$locationsComputed ??=
          Computed<List<VPNLocation>>(() => super.locations, name: '_LocationsStore.locations'))
      .value;
  Computed<List<VPNLocation>>? _$topLocationsComputed;

  @override
  List<VPNLocation> get topLocations =>
      (_$topLocationsComputed ??= Computed<List<VPNLocation>>(() => super.topLocations,
              name: '_LocationsStore.topLocations'))
          .value;
  Computed<bool?>? _$isEmptyComputed;

  @override
  bool? get isEmpty =>
      (_$isEmptyComputed ??= Computed<bool?>(() => super.isEmpty, name: '_LocationsStore.isEmpty'))
          .value;
  Computed<VPNLocation?>? _$randomLocationComputed;

  @override
  VPNLocation? get randomLocation =>
      (_$randomLocationComputed ??= Computed<VPNLocation?>(() => super.randomLocation,
              name: '_LocationsStore.randomLocation'))
          .value;

  late final _$_clearFetchedLocationsAtom =
      Atom(name: '_LocationsStore._clearFetchedLocations', context: context);

  bool get clearFetchedLocations {
    _$_clearFetchedLocationsAtom.reportRead();
    return super._clearFetchedLocations;
  }

  @override
  bool get _clearFetchedLocations => clearFetchedLocations;

  @override
  set _clearFetchedLocations(bool value) {
    _$_clearFetchedLocationsAtom.reportWrite(value, super._clearFetchedLocations, () {
      super._clearFetchedLocations = value;
    });
  }

  late final _$selectedLocationAtom =
      Atom(name: '_LocationsStore.selectedLocation', context: context);

  @override
  VPNLocation? get selectedLocation {
    _$selectedLocationAtom.reportRead();
    return super.selectedLocation;
  }

  @override
  set selectedLocation(VPNLocation? value) {
    _$selectedLocationAtom.reportWrite(value, super.selectedLocation, () {
      super.selectedLocation = value;
    });
  }

  late final _$_dcLocationsFutureAtom =
      Atom(name: '_LocationsStore._dcLocationsFuture', context: context);

  ObservableFuture<VPNLocations> get dcLocationsFuture {
    _$_dcLocationsFutureAtom.reportRead();
    return super._dcLocationsFuture;
  }

  @override
  ObservableFuture<VPNLocations> get _dcLocationsFuture => dcLocationsFuture;

  bool __dcLocationsFutureIsInitialized = false;

  @override
  set _dcLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$_dcLocationsFutureAtom
        .reportWrite(value, __dcLocationsFutureIsInitialized ? super._dcLocationsFuture : null, () {
      super._dcLocationsFuture = value;
      __dcLocationsFutureIsInitialized = true;
    });
  }

  late final _$_residentialLocationsFutureAtom =
      Atom(name: '_LocationsStore._residentialLocationsFuture', context: context);

  ObservableFuture<VPNLocations> get residentialLocationsFuture {
    _$_residentialLocationsFutureAtom.reportRead();
    return super._residentialLocationsFuture;
  }

  @override
  ObservableFuture<VPNLocations> get _residentialLocationsFuture => residentialLocationsFuture;

  bool __residentialLocationsFutureIsInitialized = false;

  @override
  set _residentialLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$_residentialLocationsFutureAtom.reportWrite(
        value, __residentialLocationsFutureIsInitialized ? super._residentialLocationsFuture : null,
        () {
      super._residentialLocationsFuture = value;
      __residentialLocationsFutureIsInitialized = true;
    });
  }

  late final _$_recentLocationsFutureAtom =
      Atom(name: '_LocationsStore._recentLocationsFuture', context: context);

  ObservableFuture<List<VPNLocation>> get recentLocationsFuture {
    _$_recentLocationsFutureAtom.reportRead();
    return super._recentLocationsFuture;
  }

  @override
  ObservableFuture<List<VPNLocation>> get _recentLocationsFuture => recentLocationsFuture;

  bool __recentLocationsFutureIsInitialized = false;

  @override
  set _recentLocationsFuture(ObservableFuture<List<VPNLocation>> value) {
    _$_recentLocationsFutureAtom.reportWrite(
        value, __recentLocationsFutureIsInitialized ? super._recentLocationsFuture : null, () {
      super._recentLocationsFuture = value;
      __recentLocationsFutureIsInitialized = true;
    });
  }

  late final _$_refreshFutureAtom = Atom(name: '_LocationsStore._refreshFuture', context: context);

  ObservableFuture<void> get refreshFuture {
    _$_refreshFutureAtom.reportRead();
    return super._refreshFuture;
  }

  @override
  ObservableFuture<void> get _refreshFuture => refreshFuture;

  bool __refreshFutureIsInitialized = false;

  @override
  set _refreshFuture(ObservableFuture<void> value) {
    _$_refreshFutureAtom
        .reportWrite(value, __refreshFutureIsInitialized ? super._refreshFuture : null, () {
      super._refreshFuture = value;
      __refreshFutureIsInitialized = true;
    });
  }

  late final _$_searchKeywordAtom = Atom(name: '_LocationsStore._searchKeyword', context: context);

  String get searchKeyword {
    _$_searchKeywordAtom.reportRead();
    return super._searchKeyword;
  }

  @override
  String get _searchKeyword => searchKeyword;

  @override
  set _searchKeyword(String value) {
    _$_searchKeywordAtom.reportWrite(value, super._searchKeyword, () {
      super._searchKeyword = value;
    });
  }

  late final _$_ipTypeAtom = Atom(name: '_LocationsStore._ipType', context: context);

  IPType get ipType {
    _$_ipTypeAtom.reportRead();
    return super._ipType;
  }

  @override
  IPType get _ipType => ipType;

  bool __ipTypeIsInitialized = false;

  @override
  set _ipType(IPType value) {
    _$_ipTypeAtom.reportWrite(value, __ipTypeIsInitialized ? super._ipType : null, () {
      super._ipType = value;
      __ipTypeIsInitialized = true;
    });
  }

  late final _$_unavailableLocationsAtom =
      Atom(name: '_LocationsStore._unavailableLocations', context: context);

  Set<VPNLocation> get unavailableLocations {
    _$_unavailableLocationsAtom.reportRead();
    return super._unavailableLocations;
  }

  @override
  Set<VPNLocation> get _unavailableLocations => unavailableLocations;

  bool __unavailableLocationsIsInitialized = false;

  @override
  set _unavailableLocations(Set<VPNLocation> value) {
    _$_unavailableLocationsAtom.reportWrite(
        value, __unavailableLocationsIsInitialized ? super._unavailableLocations : null, () {
      super._unavailableLocations = value;
      __unavailableLocationsIsInitialized = true;
    });
  }

  late final _$refreshAsyncAction = AsyncAction('_LocationsStore.refresh', context: context);

  @override
  Future<void> refresh([IPType? ipType]) {
    return _$refreshAsyncAction.run(() => super.refresh(ipType));
  }

  late final _$refreshAllAsyncAction = AsyncAction('_LocationsStore.refreshAll', context: context);

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$_fetchLocationsAsyncAction =
      AsyncAction('_LocationsStore._fetchLocations', context: context);

  @override
  Future<VPNLocations> _fetchLocations(IPType ipType) {
    return _$_fetchLocationsAsyncAction.run(() => super._fetchLocations(ipType));
  }

  late final _$_loadLocationsAsyncAction =
      AsyncAction('_LocationsStore._loadLocations', context: context);

  @override
  Future<VPNLocations> _loadLocations(IPType ipType) {
    return _$_loadLocationsAsyncAction.run(() => super._loadLocations(ipType));
  }

  late final _$addRecentLocationAsyncAction =
      AsyncAction('_LocationsStore.addRecentLocation', context: context);

  @override
  Future<void> addRecentLocation(VPNLocation location) {
    return _$addRecentLocationAsyncAction.run(() => super.addRecentLocation(location));
  }

  late final _$setIPTypeAsyncAction = AsyncAction('_LocationsStore.setIPType', context: context);

  @override
  Future<void> setIPType(IPType type) {
    return _$setIPTypeAsyncAction.run(() => super.setIPType(type));
  }

  late final _$resetRecentLocationsAsyncAction =
      AsyncAction('_LocationsStore.resetRecentLocations', context: context);

  @override
  Future<void> resetRecentLocations() {
    return _$resetRecentLocationsAsyncAction.run(() => super.resetRecentLocations());
  }

  late final _$resetStoredLocationsAsyncAction =
      AsyncAction('_LocationsStore.resetStoredLocations', context: context);

  @override
  Future<void> resetStoredLocations() {
    return _$resetStoredLocationsAsyncAction.run(() => super.resetStoredLocations());
  }

  late final _$_LocationsStoreActionController =
      ActionController(name: '_LocationsStore', context: context);

  @override
  void setClearFetchedLocations(bool value) {
    final _$actionInfo = _$_LocationsStoreActionController.startAction(
        name: '_LocationsStore.setClearFetchedLocations');
    try {
      return super.setClearFetchedLocations(value);
    } finally {
      _$_LocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  VPNLocation findLocation(String id, {String? countryCode, IPType ipType = IPType.datacenter}) {
    final _$actionInfo =
        _$_LocationsStoreActionController.startAction(name: '_LocationsStore.findLocation');
    try {
      return super.findLocation(id, countryCode: countryCode, ipType: ipType);
    } finally {
      _$_LocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLocationKeyword(String text, [Duration duration = const Duration(milliseconds: 500)]) {
    final _$actionInfo =
        _$_LocationsStoreActionController.startAction(name: '_LocationsStore.setLocationKeyword');
    try {
      return super.setLocationKeyword(text, duration);
    } finally {
      _$_LocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedLocation: ${selectedLocation},
locationsFuture: ${locationsFuture},
availableCountries: ${availableCountries},
recentLocations: ${recentLocations},
locations: ${locations},
topLocations: ${topLocations},
isEmpty: ${isEmpty},
randomLocation: ${randomLocation}
    ''';
  }
}
