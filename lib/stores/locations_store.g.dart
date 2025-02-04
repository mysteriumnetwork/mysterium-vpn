// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsStore on _LocationsStore, Store {
  Computed<List<VPNLocation>>? _$allLocationsComputed;

  @override
  List<VPNLocation> get allLocations =>
      (_$allLocationsComputed ??= Computed<List<VPNLocation>>(() => super.allLocations,
              name: '_LocationsStore.allLocations'))
          .value;
  Computed<List<VPNLocation>>? _$topLocationsComputed;

  @override
  List<VPNLocation> get topLocations =>
      (_$topLocationsComputed ??= Computed<List<VPNLocation>>(() => super.topLocations,
              name: '_LocationsStore.topLocations'))
          .value;
  Computed<List<VPNLocation>>? _$dcLocationsComputed;

  @override
  List<VPNLocation> get dcLocations => (_$dcLocationsComputed ??=
          Computed<List<VPNLocation>>(() => super.dcLocations, name: '_LocationsStore.dcLocations'))
      .value;

  late final _$_vpnLocationsFutureAtom =
      Atom(name: '_LocationsStore._vpnLocationsFuture', context: context);

  ObservableFuture<VPNLocations> get vpnLocationsFuture {
    _$_vpnLocationsFutureAtom.reportRead();
    return super._vpnLocationsFuture;
  }

  @override
  ObservableFuture<VPNLocations> get _vpnLocationsFuture => vpnLocationsFuture;

  @override
  set _vpnLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$_vpnLocationsFutureAtom.reportWrite(value, super._vpnLocationsFuture, () {
      super._vpnLocationsFuture = value;
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

  late final _$_recentLocationsAtom =
      Atom(name: '_LocationsStore._recentLocations', context: context);

  List<VPNLocation> get recentLocations {
    _$_recentLocationsAtom.reportRead();
    return super._recentLocations;
  }

  @override
  List<VPNLocation> get _recentLocations => recentLocations;

  @override
  set _recentLocations(List<VPNLocation> value) {
    _$_recentLocationsAtom.reportWrite(value, super._recentLocations, () {
      super._recentLocations = value;
    });
  }

  late final _$fetchVPNLocationsAsyncAction =
      AsyncAction('_LocationsStore.fetchVPNLocations', context: context);

  @override
  Future<void> fetchVPNLocations() {
    return _$fetchVPNLocationsAsyncAction.run(() => super.fetchVPNLocations());
  }

  late final _$fetchRecentLocationsAsyncAction =
      AsyncAction('_LocationsStore.fetchRecentLocations', context: context);

  @override
  Future<void> fetchRecentLocations() {
    return _$fetchRecentLocationsAsyncAction.run(() => super.fetchRecentLocations());
  }

  late final _$addRecentLocationAsyncAction =
      AsyncAction('_LocationsStore.addRecentLocation', context: context);

  @override
  Future<void> addRecentLocation(VPNLocation location) {
    return _$addRecentLocationAsyncAction.run(() => super.addRecentLocation(location));
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
allLocations: ${allLocations},
topLocations: ${topLocations},
dcLocations: ${dcLocations}
    ''';
  }
}
