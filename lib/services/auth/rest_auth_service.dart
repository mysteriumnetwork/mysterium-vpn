import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';

const kAuthCheck = '/auth/check';
const kLogin = '/magic-link';
const kCompleteLogin = '/oauth/token';
const kAuthIntrospect = '/oauth/introspect';

class RestAuthService extends AuthService {
  RestAuthService({
    required Dio apiClient,
    required String scheme,
  })  : _apiClient = apiClient,
        _scheme = scheme;

  final Dio _apiClient;
  final String _scheme;
  final _securedStorage = SecureStorageService.instance;

  @override
  Future<AuthData> checkUserAuth() async {
    try {
      final accessToken = await _securedStorage.getAccessToken();

      final res = await _apiClient.get(
        kAuthCheck,
        options: Options(headers: {'Authorization': 'Bearer ${accessToken}asd'}),
      );
      final data = res.data as Map<String, dynamic>;
      final username = data['username'] as String;
      final userId = data['user_id'] as String;
      await _securedStorage.saveUserId(userId: userId);
      await _securedStorage.saveUsername(username: username);
      return AuthData(
        accessToken: accessToken,
        username: username,
        userId: data['user_id'] as String,
      );
    } on Exception catch (e) {
      if (e is KeyDoesntExistsException) {
        rethrow;
      }
      debugPrint(e.toString());
      removeLocalData();
      final error = handleException(e, message: 'Authenticating failed.Please try again');
      if (error.message == 'Unauthorized' && error.code == 401) {
        throw AuthenticationRequiredException();
      }
      throw error;
    }
  }

  @override
  Future<AuthData> completeLogin({
    required String authToken,
    required PkcePair pkcePair,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final authTokenResult = await _apiClient.post<Map<String, dynamic>>(
        kCompleteLogin,
        data: {
          'grant_type': 'authorization_code',
          'client_id': _scheme,
          'code': authToken,
          'code_verifier': pkcePair.codeVerifier,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      if (authTokenResult.data == null) {
        throw Exception('No data');
      }

      final accessToken = authTokenResult.data!['access_token'] as String;
      await _apiClient.post<Map<String, dynamic>>(
        kAuthIntrospect,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          'token': accessToken,
        },
      );
      final res = await _apiClient.get(
        kAuthCheck,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final data = res.data as Map<String, dynamic>;
      final username = data['username'] as String;
      final userId = data['user_id'] as String;
      final authData = AuthData(
        accessToken: authTokenResult.data!['access_token'] as String,
        username: username,
        userId: userId,
      );
      await _securedStorage.saveAccessToken(accessToken: authData.accessToken);
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
  Future<String?> login({
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

      if (result.data != null && result.data!.containsKey('code')) {
        return result.data!['code'] as String;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw handleException(e, message: 'Authenticating failed.Please try again');
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await removeLocalData();
  }

  Future<void> removeLocalData() async {
    await _securedStorage.removeAccessToken();
    await _securedStorage.removeUsername();
    await _securedStorage.removeUserId();
    await _securedStorage.removePkcePair();
  }

  @override
  Future<void> deleteAccount({required String email}) async {
    await Future.delayed(const Duration(seconds: 4));
  }
}
