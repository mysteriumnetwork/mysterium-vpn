// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_availabe_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UpdateAvailableStore on _UpdateAvailableStore, Store {
  Computed<bool>? _$appUpdateAvailableComputed;

  @override
  bool get appUpdateAvailable =>
      (_$appUpdateAvailableComputed ??= Computed<bool>(() => super.appUpdateAvailable,
              name: '_UpdateAvailableStore.appUpdateAvailable'))
          .value;

  late final _$newVersionFutureAtom =
      Atom(name: '_UpdateAvailableStore.newVersionFuture', context: context);

  @override
  ObservableFuture<VersionStatus?> get newVersionFuture {
    _$newVersionFutureAtom.reportRead();
    return super.newVersionFuture;
  }

  bool _newVersionFutureIsInitialized = false;

  @override
  set newVersionFuture(ObservableFuture<VersionStatus?> value) {
    _$newVersionFutureAtom
        .reportWrite(value, _newVersionFutureIsInitialized ? super.newVersionFuture : null, () {
      super.newVersionFuture = value;
      _newVersionFutureIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
newVersionFuture: ${newVersionFuture},
appUpdateAvailable: ${appUpdateAvailable}
    ''';
  }
}
