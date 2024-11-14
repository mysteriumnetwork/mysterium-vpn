// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthSessionStore on _AuthSessionStore, Store {
  late final _$_accessTokenAtom = Atom(name: '_AuthSessionStore._accessToken', context: context);

  String? get accessToken {
    _$_accessTokenAtom.reportRead();
    return super._accessToken;
  }

  @override
  String? get _accessToken => accessToken;

  @override
  set _accessToken(String? value) {
    _$_accessTokenAtom.reportWrite(value, super._accessToken, () {
      super._accessToken = value;
    });
  }

  late final _$_refreshTokenAtom = Atom(name: '_AuthSessionStore._refreshToken', context: context);

  String? get refreshToken {
    _$_refreshTokenAtom.reportRead();
    return super._refreshToken;
  }

  @override
  String? get _refreshToken => refreshToken;

  @override
  set _refreshToken(String? value) {
    _$_refreshTokenAtom.reportWrite(value, super._refreshToken, () {
      super._refreshToken = value;
    });
  }

  late final _$_AuthSessionStoreActionController =
      ActionController(name: '_AuthSessionStore', context: context);

  @override
  void setAuthenticated(String accessToken, String? refreshToken) {
    final _$actionInfo =
        _$_AuthSessionStoreActionController.startAction(name: '_AuthSessionStore.setAuthenticated');
    try {
      return super.setAuthenticated(accessToken, refreshToken);
    } finally {
      _$_AuthSessionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUnauthenticated() {
    final _$actionInfo = _$_AuthSessionStoreActionController.startAction(
        name: '_AuthSessionStore.setUnauthenticated');
    try {
      return super.setUnauthenticated();
    } finally {
      _$_AuthSessionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
