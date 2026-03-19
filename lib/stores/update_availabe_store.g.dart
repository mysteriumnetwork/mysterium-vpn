// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_availabe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UpdateAvailableStore on _UpdateAvailableStore, Store {
  Computed<bool>? _$appUpdateAvailableComputed;

  @override
  bool get appUpdateAvailable => (_$appUpdateAvailableComputed ??= Computed<bool>(
    () => super.appUpdateAvailable,
    name: '_UpdateAvailableStore.appUpdateAvailable',
  )).value;

  late final _$updateAvailabilityFutureAtom = Atom(
    name: '_UpdateAvailableStore.updateAvailabilityFuture',
    context: context,
  );

  @override
  ObservableFuture<UpdateAvailability?> get updateAvailabilityFuture {
    _$updateAvailabilityFutureAtom.reportRead();
    return super.updateAvailabilityFuture;
  }

  bool _updateAvailabilityFutureIsInitialized = false;

  @override
  set updateAvailabilityFuture(ObservableFuture<UpdateAvailability?> value) {
    _$updateAvailabilityFutureAtom.reportWrite(
      value,
      _updateAvailabilityFutureIsInitialized ? super.updateAvailabilityFuture : null,
      () {
        super.updateAvailabilityFuture = value;
        _updateAvailabilityFutureIsInitialized = true;
      },
    );
  }

  late final _$_getNewVersionStatusAsyncAction = AsyncAction(
    '_UpdateAvailableStore._getNewVersionStatus',
    context: context,
  );

  @override
  Future<UpdateAvailability?> _getNewVersionStatus() {
    return _$_getNewVersionStatusAsyncAction.run(() => super._getNewVersionStatus());
  }

  @override
  String toString() {
    return '''
updateAvailabilityFuture: ${updateAvailabilityFuture},
appUpdateAvailable: ${appUpdateAvailable}
    ''';
  }
}
