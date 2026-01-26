// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PushNotificationsStore on _PushNotificationsStore, Store {
  Computed<String?>? _$userComputed;

  @override
  String? get user =>
      (_$userComputed ??= Computed<String?>(() => super.user, name: '_PushNotificationsStore.user'))
          .value;
  Computed<bool>? _$pushNotificationsPermissionGrantedComputed;

  @override
  bool get pushNotificationsPermissionGranted => (_$pushNotificationsPermissionGrantedComputed ??=
          Computed<bool>(() => super.pushNotificationsPermissionGranted,
              name: '_PushNotificationsStore.pushNotificationsPermissionGranted'))
      .value;

  late final _$_pushNotificationsUserAtom =
      Atom(name: '_PushNotificationsStore._pushNotificationsUser', context: context);

  ObservableStream<PushNotificationsUser> get pushNotificationsUser {
    _$_pushNotificationsUserAtom.reportRead();
    return super._pushNotificationsUser;
  }

  @override
  ObservableStream<PushNotificationsUser> get _pushNotificationsUser => pushNotificationsUser;

  bool __pushNotificationsUserIsInitialized = false;

  @override
  set _pushNotificationsUser(ObservableStream<PushNotificationsUser> value) {
    _$_pushNotificationsUserAtom.reportWrite(
        value, __pushNotificationsUserIsInitialized ? super._pushNotificationsUser : null, () {
      super._pushNotificationsUser = value;
      __pushNotificationsUserIsInitialized = true;
    });
  }

  late final _$_pushNotificationsPermissionStreamAtom =
      Atom(name: '_PushNotificationsStore._pushNotificationsPermissionStream', context: context);

  ObservableStream<bool> get pushNotificationsPermissionStream {
    _$_pushNotificationsPermissionStreamAtom.reportRead();
    return super._pushNotificationsPermissionStream;
  }

  @override
  ObservableStream<bool> get _pushNotificationsPermissionStream =>
      pushNotificationsPermissionStream;

  bool __pushNotificationsPermissionStreamIsInitialized = false;

  @override
  set _pushNotificationsPermissionStream(ObservableStream<bool> value) {
    _$_pushNotificationsPermissionStreamAtom.reportWrite(
        value,
        __pushNotificationsPermissionStreamIsInitialized
            ? super._pushNotificationsPermissionStream
            : null, () {
      super._pushNotificationsPermissionStream = value;
      __pushNotificationsPermissionStreamIsInitialized = true;
    });
  }

  late final _$updatePushNotificationsPermissionsAsyncAction =
      AsyncAction('_PushNotificationsStore.updatePushNotificationsPermissions', context: context);

  @override
  Future<void> updatePushNotificationsPermissions() {
    return _$updatePushNotificationsPermissionsAsyncAction
        .run(() => super.updatePushNotificationsPermissions());
  }

  late final _$setPushNotificationsShownAsyncAction =
      AsyncAction('_PushNotificationsStore.setPushNotificationsShown', context: context);

  @override
  Future<void> setPushNotificationsShown({required bool userAllowed}) {
    return _$setPushNotificationsShownAsyncAction
        .run(() => super.setPushNotificationsShown(userAllowed: userAllowed));
  }

  late final _$shouldShowPushNotificationsPermissionPromptAsyncAction = AsyncAction(
      '_PushNotificationsStore.shouldShowPushNotificationsPermissionPrompt',
      context: context);

  @override
  Future<bool> shouldShowPushNotificationsPermissionPrompt() {
    return _$shouldShowPushNotificationsPermissionPromptAsyncAction
        .run(() => super.shouldShowPushNotificationsPermissionPrompt());
  }

  @override
  String toString() {
    return '''
user: ${user},
pushNotificationsPermissionGranted: ${pushNotificationsPermissionGranted}
    ''';
  }
}
