import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';

abstract class AuthService {
  Future<AuthData> checkUserAuth();
  Future<void> login({required String email, required PkcePair pkcePair});
  Future<void> logout();
  Future<AuthData> completeLogin({
    required String authToken,
    required PkcePair pkcePair,
  });
}
