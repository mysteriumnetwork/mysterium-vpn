import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:talker/talker.dart';

const kAuthCheck = '/auth/check';
const kLogin = '/magic-link';
const kCompleteLogin = '/oauth/token';
const kAuthIntrospect = '/oauth/introspect';

class RestAuthService extends AuthService {
  RestAuthService({
    required NetworkService networkService,
    required String scheme,
    required Talker logger,
  })  : _networkService = networkService,
        _scheme = scheme,
        _logger = logger;

  final NetworkService _networkService;
  final String _scheme;
  final _securedStorage = SecureStorageService.instance;
  final Talker _logger;

  @override
  Future<AuthData> checkUserAuth() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final accessToken = await _securedStorage.getAccessToken();

      final data = (await _networkService.get(
        kAuthCheck,
        headers: {'Authorization': 'Bearer $accessToken'},
      ))
          .data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data');
      }
      final username = data['username'] as String;
      final userId = data['user_id'] as String;
      _networkService.updateHeader(
        {'Authorization': 'Bearer $accessToken'},
      );
      await _securedStorage.saveUserId(userId: userId);
      await _securedStorage.saveUsername(username: username);
      return AuthData(
        accessToken: accessToken,
        username: username,
        userId: data['user_id'] as String,
      );
    } catch (e, stackTrace) {
      removeLocalData();
      if (e is ApiException && e.message == 'Unauthorized' && e.code == 401) {
        throw AuthenticationRequiredException();
      }
      _logger.handle(e, stackTrace);
      if (e is KeyDoesntExistsException) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<AuthData> completeLogin({
    required String authToken,
    required PkcePair pkcePair,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final tokenData = (await _networkService.post(
        kCompleteLogin,
        data: {
          'grant_type': 'authorization_code',
          'client_id': _scheme,
          'code': authToken,
          'code_verifier': pkcePair.codeVerifier,
        },
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      ))
          .data as Map<String, dynamic>?;
      if (tokenData == null) {
        throw Exception('No data');
      }

      final accessToken = tokenData['access_token'] as String;
      await _networkService.post(
        kAuthIntrospect,
        headers: {'Authorization': 'Bearer $accessToken'},
        data: {
          'token': accessToken,
        },
      );
      final userData = (await _networkService.get(
        kAuthCheck,
        headers: {'Authorization': 'Bearer $accessToken'},
      ))
          .data as Map<String, dynamic>?;

      final username = userData!['username'] as String;
      final userId = userData['user_id'] as String;
      final authData = AuthData(
        accessToken: tokenData['access_token'] as String,
        username: username,
        userId: userId,
      );
      _networkService.updateHeader(
        {'Authorization': 'Bearer ${authData.accessToken}'},
      );
      await _securedStorage.saveAccessToken(accessToken: authData.accessToken);
      await _securedStorage.saveUsername(username: authData.username);
      await _securedStorage.saveUserId(userId: authData.userId);
      return authData;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      removeLocalData();
      rethrow;
    }
  }

  @override
  Future<String?> login({
    required String email,
    required PkcePair pkcePair,
  }) async {
    try {
      final result = await _networkService.post(
        kLogin,
        data: {
          'email': email,
          'client_id': _scheme,
          'code_challenge': pkcePair.codeChallenge,
          'code_challenge_method': 'S256',
        },
      );
      final data = result.data as Map<String, dynamic>?;

      if (result.statusCode != 200) {
        throw Exception('Login failed');
      }

      if (data != null && data.containsKey('code')) {
        return data['code'] as String;
      }
      return null;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await removeLocalData();
  }

  Future<void> removeLocalData() async {
    await _securedStorage.removeAccessToken();
    await _securedStorage.removeUserId();
    await _securedStorage.removePkcePair();
  }

  @override
  Future<void> deleteAccount({required String email}) async {
    await Future.delayed(const Duration(seconds: 4));
  }
}
