// Flutter imports:
// Package imports:
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
// Project imports:

part 'auth_store.g.dart';


// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore() {
    checkUserAuth();
  }

  @readonly
  AuthStatus _authStatus = AuthStatus.unknown;

  @readonly
  String? _email = '';

  @action
  Future<void> checkUserAuth() async {
    await Future.delayed(const Duration(seconds: 5));
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
