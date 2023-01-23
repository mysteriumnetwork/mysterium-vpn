// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$_authStatusAtom =
      Atom(name: '_AuthStore._authStatus', context: context);

  AuthStatus get authStatus {
    _$_authStatusAtom.reportRead();
    return super._authStatus;
  }

  @override
  AuthStatus get _authStatus => authStatus;

  @override
  set _authStatus(AuthStatus value) {
    _$_authStatusAtom.reportWrite(value, super._authStatus, () {
      super._authStatus = value;
    });
  }

  late final _$checkUserAuthAsyncAction =
      AsyncAction('_AuthStore.checkUserAuth', context: context);

  @override
  Future<void> checkUserAuth() {
    return _$checkUserAuthAsyncAction.run(() => super.checkUserAuth());
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthStore.login', context: context);

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
