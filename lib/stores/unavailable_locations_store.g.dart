// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unavailable_locations_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UnavailableLocationsStore on _UnavailableLocationsStore, Store {
  late final _$_unavailableLocationsAtom =
      Atom(name: '_UnavailableLocationsStore._unavailableLocations', context: context);

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

  late final _$_UnavailableLocationsStoreActionController =
      ActionController(name: '_UnavailableLocationsStore', context: context);

  @override
  bool isAvailable(VPNLocation location) {
    final _$actionInfo = _$_UnavailableLocationsStoreActionController.startAction(
        name: '_UnavailableLocationsStore.isAvailable');
    try {
      return super.isAvailable(location);
    } finally {
      _$_UnavailableLocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleAvailability(VPNLocation location, {bool? availability}) {
    final _$actionInfo = _$_UnavailableLocationsStoreActionController.startAction(
        name: '_UnavailableLocationsStore.toggleAvailability');
    try {
      return super.toggleAvailability(location, availability: availability);
    } finally {
      _$_UnavailableLocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_UnavailableLocationsStoreActionController.startAction(
        name: '_UnavailableLocationsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_UnavailableLocationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
