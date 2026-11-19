import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/auth/auth_repository.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

class RestAuthRepository extends AuthRepository {
  RestAuthRepository({
    required VpnApi api,
    required NetworkService networkService,
    required AuthSessionGateway authSession,
    required Talker logger,
    required SecureStorageService securedStorage,
    required LocalDBService localDb,
    Future<Uri> Function(Uri)? resolveWebUrl,
  }) : _securedStorage = securedStorage,
       _localDb = localDb,
       _resolveWebUrl = resolveWebUrl,
       _apiAuth = api.getAuthentication(),
       _networkService = networkService,
       _authSession = authSession,
       _logger = logger {
    _init();
  }

  final Authentication _apiAuth;
  final NetworkService _networkService;

  final AuthSessionGateway _authSession;
  final SecureStorageService _securedStorage;
  final LocalDBService _localDb;
  final Future<Uri> Function(Uri)? _resolveWebUrl;
  final Talker _logger;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  late final Future<void> _ensureInitialized;

  Future<void> _init() async {
    _ensureInitialized = Platform.isWindows ? Future.value() : googleSignIn.initialize();
    await _ensureInitialized;
  }

  // TODO(Waldz): Fix schema for this endpoint (JSON encoding needed)
  Future<TokenResponse> signIn(TokenRequest request) async {
    final device = AuthorizationDevice(
      osType: Platform.operatingSystem,
      id: request.deviceId,
      title: Env.deviceName,
    );
    final response = await _networkService.post(
      '/oauth/token',
      data: {...request.toJson(), 'device': device.toJson()},
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
    return AuthUser(userId: authCheck.userId, username: authCheck.username);
  }

  @override
  // No wipe on failure: callers decide, and a garbled response is not a verdict.
  Future<TokenResponse> signInComplete({required TokenRequest tokenRequest}) =>
      signIn(tokenRequest);

  @override
  Future<String?> signInWithEmail({required String email, required PkcePair pkcePair}) async {
    await removeLocalData();

    Future<dio.Response<MagicLinkResponse>> request(String? origin) => _apiAuth.requestMagicLink(
      magicLinkRequest: MagicLinkRequest(
        email: email,
        clientId: MagicLinkRequestClientIdEnum.app,
        preferredOrigin: origin,
        codeChallenge: pkcePair.codeChallenge,
        codeChallengeMethod: MagicLinkRequestCodeChallengeMethodEnum.s256,
      ),
    );

    final origin = await _preferredOrigin();
    dio.Response<MagicLinkResponse> response;
    try {
      response = await request(origin);
    } on ApiException catch (e) {
      final status = e.response?.statusCode;
      if (origin == null || (status != 400 && status != 422)) {
        rethrow;
      }
      // Origin may not be allow-listed yet; a link to the default beats no link.
      _logger.warning('Magic link rejected with preferred origin $origin; retrying without');
      response = await request(null);
    }
    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    final result = response.data;
    if (result == null || result.code == null) {
      return null;
    }

    return result.code;
  }

  /// Reachable web-app origin for the magic link; null lets the backend use its default.
  Future<String?> _preferredOrigin() async {
    final resolve = _resolveWebUrl;
    if (resolve == null || Env.webAppUrl.isEmpty) {
      return null;
    }
    try {
      return (await resolve(Uri.https(Env.webAppUrl))).origin;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> logout({required bool invalidateRemotely}) async {
    if (invalidateRemotely) {
      try {
        await _apiAuth.logout();
      } catch (e, stackTrace) {
        _logger.handle(e, stackTrace);
      }
    }
    await removeLocalData();
    if (!Platform.isWindows) {
      await _ensureInitialized;
      await GoogleSignIn.instance.signOut();
    }
  }

  Future<void> removeLocalData() async {
    final currentUsername = _authSession.user?.username;
    _localDb.clearUser();
    await _authSession.setUnauthenticated();

    if (currentUsername != null && currentUsername.isNotEmpty) {
      _logger.info('User $currentUsername logged out');
      try {
        await _securedStorage.saveLastLoggedInUser(username: currentUsername);
      } catch (e) {
        // Bookkeeping only; it must not replace the error that caused the logout.
        _logger.warning('Could not record the last logged in user: $e');
      }
    }
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Future<String> signInWithApple() async {
    try {
      if (!await SignInWithApple.isAvailable()) {
        throw NotAvailableException();
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Env.appleClientId,
          redirectUri: Uri.parse(Env.appleRedirectUri),
        ),
      );
      return credential.identityToken!;
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException && e.code == AuthorizationErrorCode.canceled) {
        throw SignInAborted();
      }
      rethrow;
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    if (!googleSignIn.supportsAuthenticate()) {
      throw NotAvailableException();
    }
    final googleUser = await googleSignIn.authenticate(
      scopeHint: ['https://www.googleapis.com/auth/userinfo.email'],
    );
    final googleAuth = googleUser.authentication;
    return googleAuth.idToken!;
  }
}
