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

  late final _$refreshAsyncAction = AsyncAction('_LocationsStore.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
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

  late final _$_LocationsStoreActionController =
      ActionController(name: '_LocationsStore', context: context);

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
locationsFuture: ${locationsFuture},
recentLocations: ${recentLocations},
locations: ${locations},
topLocations: ${topLocations}
    ''';
  }
}
