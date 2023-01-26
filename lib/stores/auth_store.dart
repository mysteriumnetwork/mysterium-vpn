// Flutter imports:
// Package imports:
import 'package:mobx/mobx.dart';

// Project imports:

part 'auth_store.g.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore() {
    checkUserAuth();
  }

  @readonly
  AuthStatus _authStatus = AuthStatus.loading;

  @readonly
  String? _email = '';

  @action
  Future<void> checkUserAuth() async {
    _authStatus = AuthStatus.unauthenticated;
  }

  @action
  Future<void> login() async {
    _authStatus = AuthStatus.authenticated;
  }

  @action
  Future<void> logout() async {
    _authStatus = AuthStatus.unauthenticated;
  }

  @action
  Future<void> signUp({required String email}) async {
    _email = email;
  }
}
