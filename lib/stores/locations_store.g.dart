// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationsStore on _LocationsStore, Store {
  Computed<FutureStatus>? _$vpnLocationsFutureStatusComputed;

  @override
  FutureStatus get vpnLocationsFutureStatus => (_$vpnLocationsFutureStatusComputed ??=
          Computed<FutureStatus>(() => super.vpnLocationsFutureStatus,
              name: '_LocationsStore.vpnLocationsFutureStatus'))
      .value;

  late final _$fetchVPNLocationsFutureAtom =
      Atom(name: '_LocationsStore.fetchVPNLocationsFuture', context: context);

  @override
  ObservableFuture<VPNLocations> get fetchVPNLocationsFuture {
    _$fetchVPNLocationsFutureAtom.reportRead();
    return super.fetchVPNLocationsFuture;
  }

  @override
  set fetchVPNLocationsFuture(ObservableFuture<VPNLocations> value) {
    _$fetchVPNLocationsFutureAtom.reportWrite(value, super.fetchVPNLocationsFuture, () {
      super.fetchVPNLocationsFuture = value;
    });
  }

  late final _$searchKeywordAtom = Atom(name: '_LocationsStore.searchKeyword', context: context);

  @override
  String get searchKeyword {
    _$searchKeywordAtom.reportRead();
    return super.searchKeyword;
  }

  @override
  set searchKeyword(String value) {
    _$searchKeywordAtom.reportWrite(value, super.searchKeyword, () {
      super.searchKeyword = value;
    });
  }

  late final _$fetchVPNLocationsAsyncAction =
      AsyncAction('_LocationsStore.fetchVPNLocations', context: context);

  @override
  Future<VPNLocations> fetchVPNLocations() {
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
  Future<void> addRecentLocation(String location) {
    return _$addRecentLocationAsyncAction.run(() => super.addRecentLocation(location));
  }

  late final _$_LocationsStoreActionController =
      ActionController(name: '_LocationsStore', context: context);

  @override
  void setLocationKeyword(String text, [int duration = 500]) {
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
fetchVPNLocationsFuture: ${fetchVPNLocationsFuture},
searchKeyword: ${searchKeyword},
vpnLocationsFutureStatus: ${vpnLocationsFutureStatus}
    ''';
  }
}
