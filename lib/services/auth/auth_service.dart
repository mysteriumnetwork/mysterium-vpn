import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/models/token_request.dart';

abstract class AuthService {
  Future<AuthData> checkUserAuth();
  Future<String?> signInWithEmail({required String email, required PkcePair pkcePair});
  Future<String> signInWithGoogle();
  Future<String> signInWithApple();
  Future<void> logout();
  Future<AuthData> completeLogin({
    required TokenRequest tokenRequest,
  });
  Future<void> deleteAccount({
    required String email,
  });
  Future<void> disconnectAllDevices();
}
