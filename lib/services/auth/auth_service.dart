import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/models/token_request.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';

abstract class AuthService {
  Future<AuthUser> checkUserAuth();
  Future<String?> signInWithEmail({required String email, required PkcePair pkcePair});
  Future<String> signInWithGoogle();
  Future<String> signInWithApple();
  Future<AuthUser> singInComplete({
    required TokenRequest tokenRequest,
  });
  Future<void> logout();
  Future<void> deleteAccount({
    required String email,
  });
  Future<void> disconnectAllDevices();
}
