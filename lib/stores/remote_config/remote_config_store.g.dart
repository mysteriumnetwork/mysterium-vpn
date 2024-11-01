// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RemoteConfigStore on RemoteConfigStoreBase, Store {
  Computed<bool>? _$isServiceAvailableComputed;

  @override
  bool get isServiceAvailable =>
      (_$isServiceAvailableComputed ??= Computed<bool>(() => super.isServiceAvailable,
              name: 'RemoteConfigStoreBase.isServiceAvailable'))
          .value;
  Computed<String>? _$minBuildNumberComputed;

  @override
  String get minBuildNumber =>
      (_$minBuildNumberComputed ??= Computed<String>(() => super.minBuildNumber,
              name: 'RemoteConfigStoreBase.minBuildNumber'))
          .value;
  Computed<String>? _$isServiceAvailableMessageComputed;

  @override
  String get isServiceAvailableMessage => (_$isServiceAvailableMessageComputed ??= Computed<String>(
          () => super.isServiceAvailableMessage,
          name: 'RemoteConfigStoreBase.isServiceAvailableMessage'))
      .value;
  Computed<bool>? _$hideDeleteAccountComputed;

  @override
  bool get hideDeleteAccount =>
      (_$hideDeleteAccountComputed ??= Computed<bool>(() => super.hideDeleteAccount,
              name: 'RemoteConfigStoreBase.hideDeleteAccount'))
          .value;
  Computed<bool>? _$hideKillSwitchComputed;

  @override
  bool get hideKillSwitch => (_$hideKillSwitchComputed ??=
          Computed<bool>(() => super.hideKillSwitch, name: 'RemoteConfigStoreBase.hideKillSwitch'))
      .value;

  late final _$configAtom = Atom(name: 'RemoteConfigStoreBase.config', context: context);

  @override
  ObservableMap<String, dynamic> get config {
    _$configAtom.reportRead();
    return super.config;
  }

  @override
  set config(ObservableMap<String, dynamic> value) {
    _$configAtom.reportWrite(value, super.config, () {
      super.config = value;
    });
  }

  late final _$setDefaultUserAsyncAction =
      AsyncAction('RemoteConfigStoreBase.setDefaultUser', context: context);

  @override
  Future<void> setDefaultUser({required String email, required String userId}) {
    return _$setDefaultUserAsyncAction
        .run(() => super.setDefaultUser(email: email, userId: userId));
  }

  late final _$getAllRemoteConfigValuesAsyncAction =
      AsyncAction('RemoteConfigStoreBase.getAllRemoteConfigValues', context: context);

  @override
  Future<void> getAllRemoteConfigValues() {
    return _$getAllRemoteConfigValuesAsyncAction.run(() => super.getAllRemoteConfigValues());
  }

  late final _$refreshRemoteConfigValuesAsyncAction =
      AsyncAction('RemoteConfigStoreBase.refreshRemoteConfigValues', context: context);

  @override
  Future<void> refreshRemoteConfigValues() {
    return _$refreshRemoteConfigValuesAsyncAction.run(() => super.refreshRemoteConfigValues());
  }

  @override
  String toString() {
    return '''
config: ${config},
isServiceAvailable: ${isServiceAvailable},
minBuildNumber: ${minBuildNumber},
isServiceAvailableMessage: ${isServiceAvailableMessage},
hideDeleteAccount: ${hideDeleteAccount},
hideKillSwitch: ${hideKillSwitch}
    ''';
  }
}
