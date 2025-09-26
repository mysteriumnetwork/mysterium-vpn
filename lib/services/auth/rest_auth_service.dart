import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/models/token_request.dart';
import 'package:mysterium_vpn/models/token_response.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

class RestAuthService extends AuthService {
  RestAuthService({
    required VpnApi api,
    required NetworkService networkService,
    required AuthSessionStore authSessionStore,
    required Talker logger,
  })  : _apiAuth = api.getAuthentication(),
        _networkService = networkService,
        _authSessionStore = authSessionStore,
        _logger = logger {
    _init();
  }

  final Authentication _apiAuth;
  final NetworkService _networkService;

  // TODO(Kristiajn):  Remove this dependency store should not be used in a service
  final AuthSessionStore _authSessionStore;
  final _securedStorage = SecureStorageService.instance;
  final Talker _logger;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  late final Future<void> _ensureInitialized;

  Future<void> _init() async {
    _ensureInitialized = googleSignIn.initialize();
    await _ensureInitialized;
  }

  // TODO(Waldz): Fix schema for this endpoint (JSON encoding needed)
  Future<TokenResponse> signIn(TokenRequest request) async {
    final response = await _networkService.post(
      '/oauth/token',
      data: request.toJson(),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    return TokenResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /*
  Checks current authorisation session + retrieves currently authorized user.
   */
  @override
  Future<AuthUser> currentUser() async {
    final response = await _apiAuth.checkAuth();
    final authCheck = response.data!;

    return AuthUser(
      userId: authCheck.userId,
      username: authCheck.username,
    );
  }

  @override
  Future<TokenResponse> singInComplete({
    required TokenRequest tokenRequest,
  }) async {
    try {
      return await signIn(tokenRequest);
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

      final response = await _apiAuth.requestMagicLink(
        magicLinkRequest: MagicLinkRequest(
          email: email,
          clientId: MagicLinkRequestClientIdEnum.app,
          codeChallenge: pkcePair.codeChallenge,
          codeChallengeMethod: MagicLinkRequestCodeChallengeMethodEnum.s256,
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Login failed');
      }

      final result = response.data;
      if (result == null || result.code == null) {
        return null;
      }

      return result.code;
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
    if (!Platform.isWindows) {
      await _ensureInitialized;
      await GoogleSignIn.instance.signOut();
    }
  }

  Future<void> removeLocalData() async {
    final currentUsername = _authSessionStore.user?.username;
    LocalDBService.instance.clearUser();
    await _authSessionStore.setUnauthenticated();

    if (currentUsername != null && currentUsername.isNotEmpty) {
      _logger.info('User $currentUsername logged out');
      await _securedStorage.saveLastLoggedInUser(username: currentUsername);
    }
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Future<String> signInWithApple() async {
    try {
      await _ensureInitialized;
      if (!await SignInWithApple.isAvailable()) {
        throw NotAvailableException();
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Env.appleClientId,
          redirectUri: Uri.parse(Env.appleRedirectUri),
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
      if (!googleSignIn.supportsAuthenticate()) {
        throw NotAvailableException();
      }
      final googleUser = await googleSignIn.authenticate(
        scopeHint: ['https://www.googleapis.com/auth/userinfo.email'],
      );
      final googleAuth = googleUser.authentication;
      return googleAuth.idToken!;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }
}
