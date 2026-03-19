// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
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

  late final _$_authenticatingTypeAtom = Atom(
    name: '_AuthStore._authenticatingType',
    context: context,
  );

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

  late final _$signInFeatureAtom = Atom(name: '_AuthStore.signInFeature', context: context);

  @override
  ObservableFuture<String?> get signInFeature {
    _$signInFeatureAtom.reportRead();
    return super.signInFeature;
  }

  @override
  set signInFeature(ObservableFuture<String?> value) {
    _$signInFeatureAtom.reportWrite(value, super.signInFeature, () {
      super.signInFeature = value;
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

  late final _$deleteAccountFeatureAtom = Atom(
    name: '_AuthStore.deleteAccountFeature',
    context: context,
  );

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

  late final _$authenticateFeatureAtom = Atom(
    name: '_AuthStore.authenticateFeature',
    context: context,
  );

  @override
  ObservableFuture<TokenResponse>? get authenticateFeature {
    _$authenticateFeatureAtom.reportRead();
    return super.authenticateFeature;
  }

  @override
  set authenticateFeature(ObservableFuture<TokenResponse>? value) {
    _$authenticateFeatureAtom.reportWrite(value, super.authenticateFeature, () {
      super.authenticateFeature = value;
    });
  }

  late final _$getLastLoggedInUserAsyncAction = AsyncAction(
    '_AuthStore.getLastLoggedInUser',
    context: context,
  );

  @override
  Future<String?> getLastLoggedInUser() {
    return _$getLastLoggedInUserAsyncAction.run(() => super.getLastLoggedInUser());
  }

  late final _$initAuthAsyncAction = AsyncAction('_AuthStore.initAuth', context: context);

  @override
  Future<void> initAuth() {
    return _$initAuthAsyncAction.run(() => super.initAuth());
  }

  late final _$fetchAuthUserAsyncAction = AsyncAction('_AuthStore.fetchAuthUser', context: context);

  @override
  Future<void> fetchAuthUser() {
    return _$fetchAuthUserAsyncAction.run(() => super.fetchAuthUser());
  }

  late final _$authenticateAsyncAction = AsyncAction('_AuthStore.authenticate', context: context);

  @override
  Future<void> authenticate(GrantType grantType, Future<TokenResponse> feature) {
    return _$authenticateAsyncAction.run(() => super.authenticate(grantType, feature));
  }

  late final _$_initializeAuthenticatedUserAsyncAction = AsyncAction(
    '_AuthStore._initializeAuthenticatedUser',
    context: context,
  );

  @override
  Future<void> _initializeAuthenticatedUser(AuthUser user) {
    return _$_initializeAuthenticatedUserAsyncAction.run(
      () => super._initializeAuthenticatedUser(user),
    );
  }

  late final _$logoutAsyncAction = AsyncAction('_AuthStore.logout', context: context);

  @override
  Future<void> logout({bool invalidateRemotely = true}) {
    return _$logoutAsyncAction.run(() => super.logout(invalidateRemotely: invalidateRemotely));
  }

  late final _$signInwithEmailAsyncAction = AsyncAction(
    '_AuthStore.signInwithEmail',
    context: context,
  );

  @override
  Future<String?> signInwithEmail({required String email}) {
    return _$signInwithEmailAsyncAction.run(() => super.signInwithEmail(email: email));
  }

  late final _$signInWithGoogleAsyncAction = AsyncAction(
    '_AuthStore.signInWithGoogle',
    context: context,
  );

  @override
  Future<void> signInWithGoogle() {
    return _$signInWithGoogleAsyncAction.run(() => super.signInWithGoogle());
  }

  late final _$signInWithAppleAsyncAction = AsyncAction(
    '_AuthStore.signInWithApple',
    context: context,
  );

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
marketingConsent: ${marketingConsent},
signInFeature: ${signInFeature},
logoutFeature: ${logoutFeature},
deleteAccountFeature: ${deleteAccountFeature},
authenticateFeature: ${authenticateFeature}
    ''';
  }
}
