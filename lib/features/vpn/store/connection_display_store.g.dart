// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_display_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConnectionDisplayStore on _ConnectionDisplayStore, Store {
  Computed<VPNLocation?>? _$displayLocationComputed;

  @override
  VPNLocation? get displayLocation =>
      (_$displayLocationComputed ??= Computed<VPNLocation?>(
        () => super.displayLocation,
        name: '_ConnectionDisplayStore.displayLocation',
      )).value;
  Computed<VPNLocation?>? _$parentLocationComputed;

  @override
  VPNLocation? get parentLocation =>
      (_$parentLocationComputed ??= Computed<VPNLocation?>(
        () => super.parentLocation,
        name: '_ConnectionDisplayStore.parentLocation',
      )).value;
  Computed<VPNLocation?>? _$targetLocationComputed;

  @override
  VPNLocation? get targetLocation =>
      (_$targetLocationComputed ??= Computed<VPNLocation?>(
        () => super.targetLocation,
        name: '_ConnectionDisplayStore.targetLocation',
      )).value;
  Computed<bool>? _$isLocationAvailableComputed;

  @override
  bool get isLocationAvailable =>
      (_$isLocationAvailableComputed ??= Computed<bool>(
        () => super.isLocationAvailable,
        name: '_ConnectionDisplayStore.isLocationAvailable',
      )).value;
  Computed<String?>? _$connectionIPComputed;

  @override
  String? get connectionIP => (_$connectionIPComputed ??= Computed<String?>(
    () => super.connectionIP,
    name: '_ConnectionDisplayStore.connectionIP',
  )).value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_ConnectionDisplayStore.isLoading',
  )).value;
  Computed<bool>? _$isConnectedComputed;

  @override
  bool get isConnected => (_$isConnectedComputed ??= Computed<bool>(
    () => super.isConnected,
    name: '_ConnectionDisplayStore.isConnected',
  )).value;
  Computed<UserIntent?>? _$connectionIntentComputed;

  @override
  UserIntent? get connectionIntent =>
      (_$connectionIntentComputed ??= Computed<UserIntent?>(
        () => super.connectionIntent,
        name: '_ConnectionDisplayStore.connectionIntent',
      )).value;
  Computed<RateConnectionRequestModeEnum?>? _$connectionRatedComputed;

  @override
  RateConnectionRequestModeEnum? get connectionRated =>
      (_$connectionRatedComputed ??= Computed<RateConnectionRequestModeEnum?>(
        () => super.connectionRated,
        name: '_ConnectionDisplayStore.connectionRated',
      )).value;
  Computed<bool>? _$hasDifferentSelectionComputed;

  @override
  bool get hasDifferentSelection =>
      (_$hasDifferentSelectionComputed ??= Computed<bool>(
        () => super.hasDifferentSelection,
        name: '_ConnectionDisplayStore.hasDifferentSelection',
      )).value;

  @override
  String toString() {
    return '''
displayLocation: ${displayLocation},
parentLocation: ${parentLocation},
targetLocation: ${targetLocation},
isLocationAvailable: ${isLocationAvailable},
connectionIP: ${connectionIP},
isLoading: ${isLoading},
isConnected: ${isConnected},
connectionIntent: ${connectionIntent},
connectionRated: ${connectionRated},
hasDifferentSelection: ${hasDifferentSelection}
    ''';
  }
}
