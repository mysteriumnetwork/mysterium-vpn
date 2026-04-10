// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthSessionStore on _AuthSessionStore, Store {
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated => (_$isAuthenticatedComputed ??= Computed<bool>(
    () => super.isAuthenticated,
    name: '_AuthSessionStore.isAuthenticated',
  )).value;
  Computed<String?>? _$accessTokenComputed;

  @override
  String? get accessToken => (_$accessTokenComputed ??= Computed<String?>(
    () => super.accessToken,
    name: '_AuthSessionStore.accessToken',
  )).value;
  Computed<String?>? _$refreshTokenComputed;

  @override
  String? get refreshToken => (_$refreshTokenComputed ??= Computed<String?>(
    () => super.refreshToken,
    name: '_AuthSessionStore.refreshToken',
  )).value;
  Computed<AuthUser?>? _$userComputed;

  @override
  AuthUser? get user => (_$userComputed ??= Computed<AuthUser?>(
    () => super.user,
    name: '_AuthSessionStore.user',
  )).value;
  Computed<bool>? _$canBrowseAppComputed;

  @override
  bool get canBrowseApp => (_$canBrowseAppComputed ??= Computed<bool>(
    () => super.canBrowseApp,
    name: '_AuthSessionStore.canBrowseApp',
  )).value;

  late final _$statusAtom = Atom(
    name: '_AuthSessionStore.status',
    context: context,
  );

  @override
  AuthStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$authShownAtom = Atom(
    name: '_AuthSessionStore.authShown',
    context: context,
  );

  @override
  bool get authShown {
    _$authShownAtom.reportRead();
    return super.authShown;
  }

  @override
  set authShown(bool value) {
    _$authShownAtom.reportWrite(value, super.authShown, () {
      super.authShown = value;
    });
  }

  late final _$_accessTokenFutureAtom = Atom(
    name: '_AuthSessionStore._accessTokenFuture',
    context: context,
  );

  ObservableFuture<String?> get accessTokenFuture {
    _$_accessTokenFutureAtom.reportRead();
    return super._accessTokenFuture;
  }

  @override
  ObservableFuture<String?> get _accessTokenFuture => accessTokenFuture;

  bool __accessTokenFutureIsInitialized = false;

  @override
  set _accessTokenFuture(ObservableFuture<String?> value) {
    _$_accessTokenFutureAtom.reportWrite(
      value,
      __accessTokenFutureIsInitialized ? super._accessTokenFuture : null,
      () {
        super._accessTokenFuture = value;
        __accessTokenFutureIsInitialized = true;
      },
    );
  }

  late final _$_refreshTokenFutureAtom = Atom(
    name: '_AuthSessionStore._refreshTokenFuture',
    context: context,
  );

  ObservableFuture<String?> get refreshTokenFuture {
    _$_refreshTokenFutureAtom.reportRead();
    return super._refreshTokenFuture;
  }

  @override
  ObservableFuture<String?> get _refreshTokenFuture => refreshTokenFuture;

  bool __refreshTokenFutureIsInitialized = false;

  @override
  set _refreshTokenFuture(ObservableFuture<String?> value) {
    _$_refreshTokenFutureAtom.reportWrite(
      value,
      __refreshTokenFutureIsInitialized ? super._refreshTokenFuture : null,
      () {
        super._refreshTokenFuture = value;
        __refreshTokenFutureIsInitialized = true;
      },
    );
  }

  late final _$_userFutureAtom = Atom(
    name: '_AuthSessionStore._userFuture',
    context: context,
  );

  ObservableFuture<AuthUser?> get userFuture {
    _$_userFutureAtom.reportRead();
    return super._userFuture;
  }

  @override
  ObservableFuture<AuthUser?> get _userFuture => userFuture;

  bool __userFutureIsInitialized = false;

  @override
  set _userFuture(ObservableFuture<AuthUser?> value) {
    _$_userFutureAtom.reportWrite(
      value,
      __userFutureIsInitialized ? super._userFuture : null,
      () {
        super._userFuture = value;
        __userFutureIsInitialized = true;
      },
    );
  }

  late final _$initStoreAsyncAction = AsyncAction(
    '_AuthSessionStore.initStore',
    context: context,
  );

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  late final _$setAuthenticatedAsyncAction = AsyncAction(
    '_AuthSessionStore.setAuthenticated',
    context: context,
  );

  @override
  Future<void> setAuthenticated(String accessToken, String? refreshToken) {
    return _$setAuthenticatedAsyncAction.run(
      () => super.setAuthenticated(accessToken, refreshToken),
    );
  }

  late final _$setAuthenticatedUserAsyncAction = AsyncAction(
    '_AuthSessionStore.setAuthenticatedUser',
    context: context,
  );

  @override
  Future<void> setAuthenticatedUser(AuthUser user) {
    return _$setAuthenticatedUserAsyncAction.run(
      () => super.setAuthenticatedUser(user),
    );
  }

  late final _$setUnauthenticatedAsyncAction = AsyncAction(
    '_AuthSessionStore.setUnauthenticated',
    context: context,
  );

  @override
  Future<void> setUnauthenticated() {
    return _$setUnauthenticatedAsyncAction.run(
      () => super.setUnauthenticated(),
    );
  }

  @override
  String toString() {
    return '''
status: ${status},
authShown: ${authShown},
isAuthenticated: ${isAuthenticated},
accessToken: ${accessToken},
refreshToken: ${refreshToken},
user: ${user},
canBrowseApp: ${canBrowseApp}
    ''';
  }
}
