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

  late final _$_pkcePairAtom =
      Atom(name: '_AuthStore._pkcePair', context: context);

  PkcePair? get pkcePair {
    _$_pkcePairAtom.reportRead();
    return super._pkcePair;
  }

  @override
  PkcePair? get _pkcePair => pkcePair;

  @override
  set _pkcePair(PkcePair? value) {
    _$_pkcePairAtom.reportWrite(value, super._pkcePair, () {
      super._pkcePair = value;
    });
  }

  late final _$_emailAtom = Atom(name: '_AuthStore._email', context: context);

  String get email {
    _$_emailAtom.reportRead();
    return super._email;
  }

  @override
  String get _email => email;

  @override
  set _email(String value) {
    _$_emailAtom.reportWrite(value, super._email, () {
      super._email = value;
    });
  }

  late final _$_authDataAtom =
      Atom(name: '_AuthStore._authData', context: context);

  AuthData? get authData {
    _$_authDataAtom.reportRead();
    return super._authData;
  }

  @override
  AuthData? get _authData => authData;

  @override
  set _authData(AuthData? value) {
    _$_authDataAtom.reportWrite(value, super._authData, () {
      super._authData = value;
    });
  }

  late final _$loginFeatureAtom =
      Atom(name: '_AuthStore.loginFeature', context: context);

  @override
  ObservableFuture<String?> get loginFeature {
    _$loginFeatureAtom.reportRead();
    return super.loginFeature;
  }

  @override
  set loginFeature(ObservableFuture<String?> value) {
    _$loginFeatureAtom.reportWrite(value, super.loginFeature, () {
      super.loginFeature = value;
    });
  }

  late final _$logoutFeatureAtom =
      Atom(name: '_AuthStore.logoutFeature', context: context);

  @override
  ObservableFuture<void> get logoutFeature {
    _$logoutFeatureAtom.reportRead();
    return super.logoutFeature;
  }

  @override
  set logoutFeature(ObservableFuture<void> value) {
    _$logoutFeatureAtom.reportWrite(value, super.logoutFeature, () {
      super.logoutFeature = value;
    });
  }

  late final _$deleteAccountFeatureAtom =
      Atom(name: '_AuthStore.deleteAccountFeature', context: context);

  @override
  ObservableFuture<void> get deleteAccountFeature {
    _$deleteAccountFeatureAtom.reportRead();
    return super.deleteAccountFeature;
  }

  @override
  set deleteAccountFeature(ObservableFuture<void> value) {
    _$deleteAccountFeatureAtom.reportWrite(value, super.deleteAccountFeature,
        () {
      super.deleteAccountFeature = value;
    });
  }

  late final _$authenticateFeatureAtom =
      Atom(name: '_AuthStore.authenticateFeature', context: context);

  @override
  ObservableFuture<AuthData?> get authenticateFeature {
    _$authenticateFeatureAtom.reportRead();
    return super.authenticateFeature;
  }

  @override
  set authenticateFeature(ObservableFuture<AuthData?> value) {
    _$authenticateFeatureAtom.reportWrite(value, super.authenticateFeature, () {
      super.authenticateFeature = value;
    });
  }

  late final _$initAuthAsyncAction =
      AsyncAction('_AuthStore.initAuth', context: context);

  @override
  Future<void> initAuth() {
    return _$initAuthAsyncAction.run(() => super.initAuth());
  }

  late final _$authenticateAsyncAction =
      AsyncAction('_AuthStore.authenticate', context: context);

  @override
  Future<void> authenticate({Uri? appLink, String? code}) {
    return _$authenticateAsyncAction
        .run(() => super.authenticate(appLink: appLink, code: code));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$loginAsyncAction =
      AsyncAction('_AuthStore.login', context: context);

  @override
  Future<String?> login({required String email}) {
    return _$loginAsyncAction.run(() => super.login(email: email));
  }

  late final _$loginDesktopAsyncAction =
      AsyncAction('_AuthStore.loginDesktop', context: context);

  @override
  Future<void> loginDesktop() {
    return _$loginDesktopAsyncAction.run(() => super.loginDesktop());
  }

  @override
  String toString() {
    return '''
loginFeature: ${loginFeature},
logoutFeature: ${logoutFeature},
deleteAccountFeature: ${deleteAccountFeature},
authenticateFeature: ${authenticateFeature}
    ''';
  }
}
