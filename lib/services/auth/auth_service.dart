import 'package:mysterium_vpn/models/auth_data.dart';

abstract class AuthService {
  Future<AuthData> checkUserAuth();
  Future<void> login({required String email});
  Future<void> logout();
  Future<AuthData> completeLogin({
    required String authToken,
  });
}
