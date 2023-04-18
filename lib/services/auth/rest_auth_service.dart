import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/exceptions/key_does_not_exists.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';

const kAuthCheck = '/auth/check';
const kLogin = '/magic-link';
const kCompleteLogin = '/auth/login-complete';

class RestAuthService extends AuthService {
  RestAuthService({
    required Dio apiClient,
    required String scheme,
  })  : _apiClient = apiClient,
        _scheme = scheme;

  final Dio _apiClient;
  final String _scheme;
  final _securedStorage = SecureStorageService();

  @override
  Future<AuthData> checkUserAuth() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final authToken = await _securedStorage.getAccessToken();

      final res = await _apiClient.get(
        kAuthCheck,
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      final data = res.data as Map<String, dynamic>;
      final username = data['username'] as String;
      final userId = data['user_id'] as String;
      await _securedStorage.saveUserId(userId: userId);
      await _securedStorage.saveUsername(username: username);
      return AuthData(
        authToken: authToken,
        username: username,
        userId: data['user_id'] as String,
      );
    } on Exception catch (e) {
      if (e is KeyDoesntExistsException) {
        rethrow;
      }
      debugPrint(e.toString());
      removeLocalData();
      throw handleException(e, message: 'Authenticating failed.Please try again');
    }
  }

  @override
  Future<AuthData> completeLogin({
    required String authToken,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final result = await _apiClient.post<Map<String, dynamic>>(
        kCompleteLogin,
        data: {'token': authToken},
      );
      if (result.data == null) {
        throw Exception('No data');
      }

      final authData = AuthData.fromJson(result.data!);
      await _securedStorage.saveAccessToken(accessToken: authData.authToken);
      await _securedStorage.saveUsername(username: authData.username);
      await _securedStorage.saveUserId(userId: authData.userId);
      return authData;
    } on Exception catch (e) {
      debugPrint(e.toString());
      removeLocalData();
      throw handleException(e, message: 'Authenticating failed.Please try again');
    }
  }

  @override
  Future<void> login({
    required String email,
    required PkcePair pkcePair,
  }) async {
    try {
      final result = await _apiClient.post<Map<String, dynamic>>(
        kLogin,
        data: {
          'email': email,
          'client_id': _scheme,
          'code_challenge': pkcePair.codeChallenge,
          'code_challenge_method': 'S256',
        },
      );

      if (result.statusCode != 200) {
        throw Exception('Login failed');
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e, message: 'Authenticating failed.Please try again');
    }
  }

  @override
  Future<void> logout() async {
    await removeLocalData();
  }

  Future<void> removeLocalData() async {
    await _securedStorage.removeAccessToken();
    await _securedStorage.removeUsername();
    await _securedStorage.removeUserId();
  }
}
