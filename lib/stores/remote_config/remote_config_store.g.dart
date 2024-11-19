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
  Computed<String>? _$minMacosBuildNumberComputed;

  @override
  String get minMacosBuildNumber =>
      (_$minMacosBuildNumberComputed ??= Computed<String>(() => super.minMacosBuildNumber,
              name: 'RemoteConfigStoreBase.minMacosBuildNumber'))
          .value;
  Computed<String>? _$minWindowsStandAloneBuildNumberComputed;

  @override
  String get minWindowsStandAloneBuildNumber => (_$minWindowsStandAloneBuildNumberComputed ??=
          Computed<String>(() => super.minWindowsStandAloneBuildNumber,
              name: 'RemoteConfigStoreBase.minWindowsStandAloneBuildNumber'))
      .value;
  Computed<String>? _$minWindowsBuildNumberComputed;

  @override
  String get minWindowsBuildNumber =>
      (_$minWindowsBuildNumberComputed ??= Computed<String>(() => super.minWindowsBuildNumber,
              name: 'RemoteConfigStoreBase.minWindowsBuildNumber'))
          .value;
  Computed<String>? _$minAndroidBuildNumberComputed;

  @override
  String get minAndroidBuildNumber =>
      (_$minAndroidBuildNumberComputed ??= Computed<String>(() => super.minAndroidBuildNumber,
              name: 'RemoteConfigStoreBase.minAndroidBuildNumber'))
          .value;
  Computed<String>? _$minIosBuildNumberComputed;

  @override
  String get minIosBuildNumber =>
      (_$minIosBuildNumberComputed ??= Computed<String>(() => super.minIosBuildNumber,
              name: 'RemoteConfigStoreBase.minIosBuildNumber'))
          .value;
  Computed<bool>? _$hideReedemCodeComputed;

  @override
  bool get hideReedemCode => (_$hideReedemCodeComputed ??=
          Computed<bool>(() => super.hideReedemCode, name: 'RemoteConfigStoreBase.hideReedemCode'))
      .value;
  Computed<bool>? _$hideMalwareBlockerComputed;

  @override
  bool get hideMalwareBlocker =>
      (_$hideMalwareBlockerComputed ??= Computed<bool>(() => super.hideMalwareBlocker,
              name: 'RemoteConfigStoreBase.hideMalwareBlocker'))
          .value;
  Computed<bool>? _$hideNotSafeContentBlockerComputed;

  @override
  bool get hideNotSafeContentBlocker =>
      (_$hideNotSafeContentBlockerComputed ??= Computed<bool>(() => super.hideNotSafeContentBlocker,
              name: 'RemoteConfigStoreBase.hideNotSafeContentBlocker'))
          .value;
  Computed<String>? _$mainDnsAddressComputed;

  @override
  String get mainDnsAddress =>
      (_$mainDnsAddressComputed ??= Computed<String>(() => super.mainDnsAddress,
              name: 'RemoteConfigStoreBase.mainDnsAddress'))
          .value;
  Computed<String>? _$malwareBlockerDnsAddressComputed;

  @override
  String get malwareBlockerDnsAddress =>
      (_$malwareBlockerDnsAddressComputed ??= Computed<String>(() => super.malwareBlockerDnsAddress,
              name: 'RemoteConfigStoreBase.malwareBlockerDnsAddress'))
          .value;
  Computed<String>? _$notSafeContentBlockerDnsAddressComputed;

  @override
  String get notSafeContentBlockerDnsAddress => (_$notSafeContentBlockerDnsAddressComputed ??=
          Computed<String>(() => super.notSafeContentBlockerDnsAddress,
              name: 'RemoteConfigStoreBase.notSafeContentBlockerDnsAddress'))
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
isServiceAvailableMessage: ${isServiceAvailableMessage},
hideDeleteAccount: ${hideDeleteAccount},
hideKillSwitch: ${hideKillSwitch},
minMacosBuildNumber: ${minMacosBuildNumber},
minWindowsStandAloneBuildNumber: ${minWindowsStandAloneBuildNumber},
minWindowsBuildNumber: ${minWindowsBuildNumber},
minAndroidBuildNumber: ${minAndroidBuildNumber},
minIosBuildNumber: ${minIosBuildNumber},
hideReedemCode: ${hideReedemCode},
hideMalwareBlocker: ${hideMalwareBlocker},
hideNotSafeContentBlocker: ${hideNotSafeContentBlocker},
mainDnsAddress: ${mainDnsAddress},
malwareBlockerDnsAddress: ${malwareBlockerDnsAddress},
notSafeContentBlockerDnsAddress: ${notSafeContentBlockerDnsAddress}
    ''';
  }
}
