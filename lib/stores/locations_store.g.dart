// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsStore on _LocationsStore, Store {
  Computed<ObservableStream<VPNLocations>>? _$locationsStreamComputed;

  @override
  ObservableStream<VPNLocations> get locationsStream => (_$locationsStreamComputed ??=
          Computed<ObservableStream<VPNLocations>>(() => super.locationsStream,
              name: '_LocationsStore.locationsStream'))
      .value;
  Computed<Set<String>>? _$availableCountriesComputed;

  @override
  Set<String> get availableCountries =>
      (_$availableCountriesComputed ??= Computed<Set<String>>(() => super.availableCountries,
              name: '_LocationsStore.availableCountries'))
          .value;
  Computed<bool>? _$_locationsNotEmptyComputed;

  @override
  bool get _locationsNotEmpty =>
      (_$_locationsNotEmptyComputed ??= Computed<bool>(() => super._locationsNotEmpty,
              name: '_LocationsStore._locationsNotEmpty'))
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
  Computed<VPNLocation?>? _$randomLocationComputed;

  @override
  VPNLocation? get randomLocation =>
      (_$randomLocationComputed ??= Computed<VPNLocation?>(() => super.randomLocation,
              name: '_LocationsStore.randomLocation'))
          .value;

  late final _$_dcLocationsStreamAtom =
      Atom(name: '_LocationsStore._dcLocationsStream', context: context);

  ObservableStream<VPNLocations> get dcLocationsStream {
    _$_dcLocationsStreamAtom.reportRead();
    return super._dcLocationsStream;
  }

  @override
  ObservableStream<VPNLocations> get _dcLocationsStream => dcLocationsStream;

  bool __dcLocationsStreamIsInitialized = false;

  @override
  set _dcLocationsStream(ObservableStream<VPNLocations> value) {
    _$_dcLocationsStreamAtom
        .reportWrite(value, __dcLocationsStreamIsInitialized ? super._dcLocationsStream : null, () {
      super._dcLocationsStream = value;
      __dcLocationsStreamIsInitialized = true;
    });
  }

  late final _$_residentialLocationsStreamAtom =
      Atom(name: '_LocationsStore._residentialLocationsStream', context: context);

  ObservableStream<VPNLocations> get residentialLocationsStream {
    _$_residentialLocationsStreamAtom.reportRead();
    return super._residentialLocationsStream;
  }

  @override
  ObservableStream<VPNLocations> get _residentialLocationsStream => residentialLocationsStream;

  bool __residentialLocationsStreamIsInitialized = false;

  @override
  set _residentialLocationsStream(ObservableStream<VPNLocations> value) {
    _$_residentialLocationsStreamAtom.reportWrite(
        value, __residentialLocationsStreamIsInitialized ? super._residentialLocationsStream : null,
        () {
      super._residentialLocationsStream = value;
      __residentialLocationsStreamIsInitialized = true;
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

  late final _$_fetchRecentLocationsAsyncAction =
      AsyncAction('_LocationsStore._fetchRecentLocations', context: context);

  @override
  Future<List<VPNLocation>> _fetchRecentLocations() {
    return _$_fetchRecentLocationsAsyncAction.run(() => super._fetchRecentLocations());
  }

  late final _$refreshAsyncAction = AsyncAction('_LocationsStore.refresh', context: context);

  @override
  Future<void> refresh([IPType? ipType]) {
    return _$refreshAsyncAction.run(() => super.refresh(ipType));
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
locationsStream: ${locationsStream},
availableCountries: ${availableCountries},
recentLocations: ${recentLocations},
locations: ${locations},
topLocations: ${topLocations},
randomLocation: ${randomLocation}
    ''';
  }
}
