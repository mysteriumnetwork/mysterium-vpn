// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intercom_mobile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IntercomMobileStore on _IntercomMobileStore, Store {
  late final _$_intercomFutureAtom =
      Atom(name: '_IntercomMobileStore._intercomFuture', context: context);

  @override
  ObservableFuture<Intercom> get _intercomFuture {
    _$_intercomFutureAtom.reportRead();
    return super._intercomFuture;
  }

  bool __intercomFutureIsInitialized = false;

  @override
  set _intercomFuture(ObservableFuture<Intercom> value) {
    _$_intercomFutureAtom
        .reportWrite(value, __intercomFutureIsInitialized ? super._intercomFuture : null, () {
      super._intercomFuture = value;
      __intercomFutureIsInitialized = true;
    });
  }

  late final _$_isUserLoggedInAtom =
      Atom(name: '_IntercomMobileStore._isUserLoggedIn', context: context);

  @override
  bool get _isUserLoggedIn {
    _$_isUserLoggedInAtom.reportRead();
    return super._isUserLoggedIn;
  }

  @override
  set _isUserLoggedIn(bool value) {
    _$_isUserLoggedInAtom.reportWrite(value, super._isUserLoggedIn, () {
      super._isUserLoggedIn = value;
    });
  }

  late final _$registerUserAsyncAction =
      AsyncAction('_IntercomMobileStore.registerUser', context: context);

  @override
  Future<void> registerUser({String? email}) {
    return _$registerUserAsyncAction.run(() => super.registerUser(email: email));
  }

  late final _$logoutAsyncAction = AsyncAction('_IntercomMobileStore.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$updateUserAsyncAction =
      AsyncAction('_IntercomMobileStore.updateUser', context: context);

  @override
  Future<void> updateUser(String email, String userId) {
    return _$updateUserAsyncAction.run(() => super.updateUser(email, userId));
  }

  late final _$displayMessageComposerAsyncAction =
      AsyncAction('_IntercomMobileStore.displayMessageComposer', context: context);

  @override
  Future<void> displayMessageComposer(String message) {
    return _$displayMessageComposerAsyncAction.run(() => super.displayMessageComposer(message));
  }

  late final _$displayMessengerAsyncAction =
      AsyncAction('_IntercomMobileStore.displayMessenger', context: context);

  @override
  Future<void> displayMessenger() {
    return _$displayMessengerAsyncAction.run(() => super.displayMessenger());
  }

  late final _$displayHelpCenterAsyncAction =
      AsyncAction('_IntercomMobileStore.displayHelpCenter', context: context);

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
