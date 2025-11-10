import 'package:mysterium_vpn/models/models.dart';

abstract class AuthService {
  Future<AuthUser> currentUser();
  Future<String?> signInWithEmail({required String email, required PkcePair pkcePair});
  Future<String> signInWithGoogle();
  Future<String> signInWithApple();
  Future<TokenResponse> signInComplete({required TokenRequest tokenRequest});
  Future<void> logout({required bool invalidateRemotely});
  Future<void> deleteAccount();
}
