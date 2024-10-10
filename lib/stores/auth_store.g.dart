// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$_authStatusAtom = Atom(name: '_AuthStore._authStatus', context: context);

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

  late final _$_pkcePairAtom = Atom(name: '_AuthStore._pkcePair', context: context);

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

  late final _$_authenticatingTypeAtom =
      Atom(name: '_AuthStore._authenticatingType', context: context);

  GrantType? get authenticatingType {
    _$_authenticatingTypeAtom.reportRead();
    return super._authenticatingType;
  }

  @override
  GrantType? get _authenticatingType => authenticatingType;

  @override
  set _authenticatingType(GrantType? value) {
    _$_authenticatingTypeAtom.reportWrite(value, super._authenticatingType, () {
      super._authenticatingType = value;
    });
  }

  late final _$emailAtom = Atom(name: '_AuthStore.email', context: context);

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$temporaryEmailAtom = Atom(name: '_AuthStore.temporaryEmail', context: context);

  @override
  String? get temporaryEmail {
    _$temporaryEmailAtom.reportRead();
    return super.temporaryEmail;
  }

  @override
  set temporaryEmail(String? value) {
    _$temporaryEmailAtom.reportWrite(value, super.temporaryEmail, () {
      super.temporaryEmail = value;
    });
  }

  late final _$_authDataAtom = Atom(name: '_AuthStore._authData', context: context);

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

  late final _$marketingConsentAtom = Atom(name: '_AuthStore.marketingConsent', context: context);

  @override
  bool get marketingConsent {
    _$marketingConsentAtom.reportRead();
    return super.marketingConsent;
  }

  @override
  set marketingConsent(bool value) {
    _$marketingConsentAtom.reportWrite(value, super.marketingConsent, () {
      super.marketingConsent = value;
    });
  }

  late final _$signInFeatureFeatureAtom =
      Atom(name: '_AuthStore.signInFeatureFeature', context: context);

  @override
  ObservableFuture<String?> get signInFeatureFeature {
    _$signInFeatureFeatureAtom.reportRead();
    return super.signInFeatureFeature;
  }

  @override
  set signInFeatureFeature(ObservableFuture<String?> value) {
    _$signInFeatureFeatureAtom.reportWrite(value, super.signInFeatureFeature, () {
      super.signInFeatureFeature = value;
    });
  }

  late final _$logoutFeatureAtom = Atom(name: '_AuthStore.logoutFeature', context: context);

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
    _$deleteAccountFeatureAtom.reportWrite(value, super.deleteAccountFeature, () {
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

  late final _$initAuthAsyncAction = AsyncAction('_AuthStore.initAuth', context: context);

  @override
  Future<void> initAuth() {
    return _$initAuthAsyncAction.run(() => super.initAuth());
  }

  late final _$authenticateAsyncAction = AsyncAction('_AuthStore.authenticate', context: context);

  @override
  Future<void> authenticate({required GrantType grantType, String? code}) {
    return _$authenticateAsyncAction
        .run(() => super.authenticate(grantType: grantType, code: code));
  }

  late final _$logoutAsyncAction = AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout({String? email, bool? invalidateExpiredToken}) {
    return _$logoutAsyncAction
        .run(() => super.logout(email: email, invalidateExpiredToken: invalidateExpiredToken));
  }

  late final _$logoutFromAllDevicesAsyncAction =
      AsyncAction('_AuthStore.logoutFromAllDevices', context: context);

  @override
  Future<void> logoutFromAllDevices() {
    return _$logoutFromAllDevicesAsyncAction.run(() => super.logoutFromAllDevices());
  }

  late final _$signInwithEmailAsyncAction =
      AsyncAction('_AuthStore.signInwithEmail', context: context);

  @override
  Future<String?> signInwithEmail({required String email}) {
    return _$signInwithEmailAsyncAction.run(() => super.signInwithEmail(email: email));
  }

  late final _$signInWithGoogleAsyncAction =
      AsyncAction('_AuthStore.signInWithGoogle', context: context);

  @override
  Future<void> signInWithGoogle() {
    return _$signInWithGoogleAsyncAction.run(() => super.signInWithGoogle());
  }

  late final _$signInWithAppleAsyncAction =
      AsyncAction('_AuthStore.signInWithApple', context: context);

  @override
  Future<void> signInWithApple() {
    return _$signInWithAppleAsyncAction.run(() => super.signInWithApple());
  }

  late final _$loginDesktopAsyncAction = AsyncAction('_AuthStore.loginDesktop', context: context);

  @override
  Future<void> loginDesktop() {
    return _$loginDesktopAsyncAction.run(() => super.loginDesktop());
  }

  @override
  String toString() {
    return '''
email: ${email},
temporaryEmail: ${temporaryEmail},
marketingConsent: ${marketingConsent},
signInFeatureFeature: ${signInFeatureFeature},
logoutFeature: ${logoutFeature},
deleteAccountFeature: ${deleteAccountFeature},
authenticateFeature: ${authenticateFeature}
    ''';
  }
}
