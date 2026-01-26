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

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}
