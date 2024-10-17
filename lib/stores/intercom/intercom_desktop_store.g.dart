// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intercom_desktop_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IntercomDesktopStore on _IntercomDesktopStore, Store {
  late final _$initializeAsyncAction =
      AsyncAction('_IntercomDesktopStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$registerUserAsyncAction =
      AsyncAction('_IntercomDesktopStore.registerUser', context: context);

  @override
  Future<void> registerUser({String? email}) {
    return _$registerUserAsyncAction.run(() => super.registerUser(email: email));
  }

  late final _$logoutAsyncAction = AsyncAction('_IntercomDesktopStore.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$updateUserAsyncAction =
      AsyncAction('_IntercomDesktopStore.updateUser', context: context);

  @override
  Future<void> updateUser(String email, String userId) {
    return _$updateUserAsyncAction.run(() => super.updateUser(email, userId));
  }

  late final _$displayMessageComposerAsyncAction =
      AsyncAction('_IntercomDesktopStore.displayMessageComposer', context: context);

  @override
  Future<void> displayMessageComposer(String message) {
    return _$displayMessageComposerAsyncAction.run(() => super.displayMessageComposer(message));
  }

  late final _$displayMessengerAsyncAction =
      AsyncAction('_IntercomDesktopStore.displayMessenger', context: context);

  @override
  Future<void> displayMessenger() {
    return _$displayMessengerAsyncAction.run(() => super.displayMessenger());
  }

  late final _$displayHelpCenterAsyncAction =
      AsyncAction('_IntercomDesktopStore.displayHelpCenter', context: context);

  @override
  Future<void> displayHelpCenter() {
    return _$displayHelpCenterAsyncAction.run(() => super.displayHelpCenter());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
