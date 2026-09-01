// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PushNotificationsStore on _PushNotificationsStore, Store {
  Computed<bool>? _$pushNotificationsPermissionGrantedComputed;

  @override
  bool get pushNotificationsPermissionGranted =>
      (_$pushNotificationsPermissionGrantedComputed ??= Computed<bool>(
        () => super.pushNotificationsPermissionGranted,
        name: '_PushNotificationsStore.pushNotificationsPermissionGranted',
      )).value;
  Computed<PushNotification?>? _$lastNotificationComputed;

  @override
  PushNotification? get lastNotification =>
      (_$lastNotificationComputed ??= Computed<PushNotification?>(
        () => super.lastNotification,
        name: '_PushNotificationsStore.lastNotification',
      )).value;

  late final _$_pushNotificationsPermissionStreamAtom = Atom(
    name: '_PushNotificationsStore._pushNotificationsPermissionStream',
    context: context,
  );

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
          : null,
      () {
        super._pushNotificationsPermissionStream = value;
        __pushNotificationsPermissionStreamIsInitialized = true;
      },
    );
  }

  late final _$_notificationsStreamAtom = Atom(
    name: '_PushNotificationsStore._notificationsStream',
    context: context,
  );

  ObservableStream<PushNotification> get notificationsStream {
    _$_notificationsStreamAtom.reportRead();
    return super._notificationsStream;
  }

  @override
  ObservableStream<PushNotification> get _notificationsStream => notificationsStream;

  bool __notificationsStreamIsInitialized = false;

  @override
  set _notificationsStream(ObservableStream<PushNotification> value) {
    _$_notificationsStreamAtom.reportWrite(
      value,
      __notificationsStreamIsInitialized ? super._notificationsStream : null,
      () {
        super._notificationsStream = value;
        __notificationsStreamIsInitialized = true;
      },
    );
  }

  late final _$updatePushNotificationsPermissionsAsyncAction = AsyncAction(
    '_PushNotificationsStore.updatePushNotificationsPermissions',
    context: context,
  );

  @override
  Future<void> updatePushNotificationsPermissions() {
    return _$updatePushNotificationsPermissionsAsyncAction.run(
      () => super.updatePushNotificationsPermissions(),
    );
  }

  late final _$setPushNotificationsShownAsyncAction = AsyncAction(
    '_PushNotificationsStore.setPushNotificationsShown',
    context: context,
  );

  @override
  Future<void> setPushNotificationsShown({required bool userAllowed}) {
    return _$setPushNotificationsShownAsyncAction.run(
      () => super.setPushNotificationsShown(userAllowed: userAllowed),
    );
  }

  late final _$shouldShowPushNotificationsPermissionPromptAsyncAction = AsyncAction(
    '_PushNotificationsStore.shouldShowPushNotificationsPermissionPrompt',
    context: context,
  );

  @override
  Future<bool> shouldShowPushNotificationsPermissionPrompt() {
    return _$shouldShowPushNotificationsPermissionPromptAsyncAction.run(
      () => super.shouldShowPushNotificationsPermissionPrompt(),
    );
  }

  @override
  String toString() {
    return '''
pushNotificationsPermissionGranted: ${pushNotificationsPermissionGranted},
lastNotification: ${lastNotification}
    ''';
  }
}
