import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/models/token_request.dart';
import 'package:mysterium_vpn/models/token_response.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:talker/talker.dart';

const kAuthCheck = '/auth/check';
const kMagicLink = '/magic-link';
const kOAuthIntrospect = '/oauth/introspect';
const kDisconnectAllDevices = '/connection/disconnect-all';

class RestAuthService extends AuthService {
  RestAuthService({
    required NetworkService networkService,
    required AuthSessionStore authSessionStore,
    required Talker logger,
    required FlavorValues env,
  })  : _networkService = networkService,
        _authSessionStore = authSessionStore,
        _logger = logger,
        _env = env;

  final NetworkService _networkService;
  final AuthSessionStore _authSessionStore;
  final _securedStorage = SecureStorageService.instance;
  final Talker _logger;
  final FlavorValues _env;
  final googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  @override
  Future<AuthData> checkUserAuth() async {
    try {
      final userName = await _securedStorage.getUsername() ?? '';
      final userId = await _securedStorage.getUserId();

      // Proceed with token introspection in order to check if token is valid
      // If token is invalid, UnauthorizedInterceptor will catch it and it will be handled
      unawaited(
        _networkService.get(kAuthCheck),
      );

      return AuthData(
        username: userName,
        userId: userId,
      );
    } catch (e, stackTrace) {
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

  Future<TokenResponse> signIn(TokenRequest request) async {
    final response = await _networkService.post(
      '/oauth/token',
      data: request.toJson(),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    return TokenResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthData> singInComplete({
    required TokenRequest tokenRequest,
  }) async {
    try {
      final authTokens = await signIn(tokenRequest);
      _authSessionStore.setAuthenticated(authTokens.accessToken, authTokens.refreshToken);

      await _networkService.post(
        kOAuthIntrospect,
        data: {
          'token': authTokens.accessToken,
        },
      );

      final userData = (await _networkService.get(
        kAuthCheck,
      ))
          .data as Map<String, dynamic>?;
      // TODO(Waldz): Introduce DTO models, layer of serialization/deserialization is missing
      final username = userData!['username'] as String;

      final authData = AuthData(
        username: username,
        userId: authTokens.userId,
      );
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
  Future<String?> signInWithEmail({
    required String email,
    required PkcePair pkcePair,
  }) async {
    try {
      await removeLocalData();
      final result = await _networkService.post(
        kMagicLink,
        data: {
          'email': email,
          'client_id': 'app',
          'code_challenge': pkcePair.codeChallenge,
          'code_challenge_method': 'S256',
        },
      );
      final data = result.data as Map<String, dynamic>?;

      if (result.statusCode != 200) {
        throw Exception('Login failed');
      }

      if (data != null && data.containsKey('code')) {
        // TODO(Waldz): Introduce DTO models, layer of serialization/deserialization is missing
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
    if (!Platform.isWindows && await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
  }

  Future<void> removeLocalData() async {
    _authSessionStore.setUnauthenticated();
    await _securedStorage.removeUserId();
    await _securedStorage.removePkcePair();
    await _securedStorage.removeWireguardPrivateKey();
    await _securedStorage.removeWireguardPublicKey();
    final val = await _securedStorage.removeUsername();
    if (val != null && val.isNotEmpty) {
      _logger.info('User $val logged out');
      await _securedStorage.saveLastLoggedInUser(username: val);
    }
  }

  @override
  Future<void> deleteAccount({required String email}) async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Future<String> signInWithApple() async {
    try {
      if (!await SignInWithApple.isAvailable()) {
        throw NotAvailableException();
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: _env.appleClientId,
          redirectUri: Uri.parse(
            _env.appleRedirectUri,
          ),
        ),
      );
      return credential.identityToken!;
    } catch (e, stackTrace) {
      if (e is SignInWithAppleAuthorizationException && e.code == AuthorizationErrorCode.canceled) {
        throw SignInAborted();
      }
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw SignInAborted();
      }
      final googleAuth = await googleUser.authentication;
      return googleAuth.idToken!;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> disconnectAllDevices() async {
    try {
      await _networkService.get(
        kDisconnectAllDevices,
      );
      _logger.info('All devices disconnected');
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
    }
  }
}
