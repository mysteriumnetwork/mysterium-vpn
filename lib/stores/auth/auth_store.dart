// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/auth/auth_error.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

// Project imports:

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore({
    required AuthRepository authService,
    required AuthSessionStore authSessionStore,
    required AppLinks appLinks,
    required AnalyticsStore analyticsStore,
    required Talker logger,
    required ABTestingStore abTestingStore,
    required DeviceIDStore deviceIDStore,
    required AuthFlowRepository flow,
    required SessionRepository session,
  }) : _flow = flow,
       _session = session,
       _authService = authService,
       _authSessionStore = authSessionStore,
       _appLinks = appLinks,
       _analyticsStore = analyticsStore,
       _logger = logger,
       _abTestingStore = abTestingStore,
       _deviceIDStore = deviceIDStore {
    refreshTokenCallback = refreshAuthToken;
  }

  final AuthRepository _authService;
  final AuthSessionStore _authSessionStore;
  final AppLinks _appLinks;
  final AuthFlowRepository _flow;
  final SessionRepository _session;
  final AnalyticsStore _analyticsStore;
  final Talker _logger;
  final ABTestingStore _abTestingStore;
  final DeviceIDStore _deviceIDStore;

  @readonly
  PkcePair? _pkcePair;

  @readonly
  GrantType? _authenticatingType;

  @observable
  String? email;

  /// One-shot auth failure for the UI to translate + display. The UI consumes
  /// it (via [consumeAuthError]) after showing. Kept translation-free here so
  /// presentation stays in the view layer.
  @readonly
  AuthError? _authError;

  @action
  // ignore: use_setters_to_change_properties
  void _emitError(AuthError error) => _authError = error;

  @action
  void consumeAuthError() => _authError = null;

  @observable
  bool marketingConsent = false;

  @observable
  ObservableFuture<String?> signInFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<void> logoutFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<void> deleteAccountFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<TokenResponse>? authenticateFeature;

  @action
  Future<String?> getLastLoggedInUser() async => email ?? await _flow.lastLoggedInUser();

  @action
  Future<void> initAuth() async {
    try {
      email = await _flow.lastLoggedInUser();
      _appLinks.uriLinkStream.listen((appLink) async {
        if (_authSessionStore.isAuthenticated) {
          return;
        }
        final storedLink = await _flow.appLink();
        if (appLink.toString() != storedLink) {
          await _flow.saveAppLink(appLink.toString());

          await verifyMagicLinkAndAuthenticate(appLink);
        } else {
          Sentry.captureException(TokenAlreadyUsedException());
          _emitError(const AuthError(AuthErrorType.tokenAlreadyUsed));
        }
      });
    } catch (e) {
      _logger.handle(e);
    }
  }

  Future<void> verifyMagicLinkAndAuthenticate(Uri appLink) async {
    try {
      if (appLink.query.isEmpty) {
        throw IncorrectMagicLinkException();
      }
      final code = _getMagicLinkCode(appLink.query);
      if (code == null) {
        throw IncorrectCodeException();
      }

      if (_pkcePair == null && (_pkcePair = await _flow.pkcePair()) == null) {
        throw PkcePairNotFoundException();
      }
      authenticate(
        GrantType.email,
        _authService.signInComplete(
          tokenRequest: TokenRequest(
            deviceId: await _deviceIDStore.deviceIdFuture,
            grantType: GrantType.email,
            code: code,
            codeVerifier: _pkcePair!.codeVerifier,
          ),
        ),
      );
    } catch (e) {
      _emitError(const AuthError(AuthErrorType.incorrectMagicLink));
      Sentry.captureException(e);
      rethrow;
    }
  }

  // Proceed with token introspection in order to check if token is valid
  // If token is invalid, UnauthorizedInterceptor will catch it and it will be handled
  @action
  Future<void> fetchAuthUser() async {
    try {
      final user = await _authService.currentUser();
      await _initializeAuthenticatedUser(user);
    } on ApiException catch (e, stackTrace) {
      // We want to make call to user details endpoint to introspect AccessToken, and if it's invalid when logout the user
      if (e.code == 401 || e.response?.statusCode == 401) {
        if (_refreshInconclusive) {
          // One shot: the next 401 counts, so a latched flag cannot strand us.
          _refreshInconclusive = false;
          _logger.warning('Access token refused, but the refresh never got a verdict');
          return;
        }
        _logger.error('User AccessToken invalid');
        await _authSessionStore.setUnauthenticated();
        return;
      }

      _logger.handle(e, stackTrace);
      _emitError(AuthError(AuthErrorType.serverMessage, e.message));
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      _emitError(const AuthError(AuthErrorType.authenticationFailed));
    }
  }

  @action
  Future<void> authenticate(GrantType grantType, Future<TokenResponse> feature) async {
    final TokenResponse authTokens;
    try {
      final pending = ObservableFuture(feature);
      authenticateFeature = pending;
      authTokens = await pending;
    } on ApiException catch (e) {
      _emitError(AuthError(AuthErrorType.serverMessage, e.message));
      return;
    } catch (e) {
      _emitError(const AuthError(AuthErrorType.authenticationFailed));
      return;
    }

    try {
      await _authSessionStore.setAuthenticated(authTokens.accessToken, authTokens.refreshToken);
    } catch (e) {
      // Already in memory, so an unwritable keychain is not a failed login.
      _logger.warning('Could not persist new credentials: $e');
    }
    _analyticsStore.setLogin(grantType);
  }

  @action
  Future<void> _initializeAuthenticatedUser(AuthUser user) async {
    try {
      await _authSessionStore.setAuthenticatedUser(user);
    } catch (e) {
      // Already in memory, so an unwritable keychain is not a failed sign-in.
      _logger.warning('Could not persist the signed-in user: $e');
    }
    _initializeAnalyticsStores(username: user.username, userId: user.userId);

    // Set auth user
    await _session.cacheUserRecord(user);
    final userSettings = await _session.userRecord();
    _logger.info(userSettings.toString());
  }

  Future<void> _initializeAnalyticsStores({
    required String username,
    required String userId,
  }) async {
    if (kDebugMode) {
      debugPrint('userId: $userId, username: $username');
    }
    await _abTestingStore.configFuture;
    await _analyticsStore.setUserId(userId);
    await _analyticsStore.setUserProperty(
      AnalyticsUserProperty.fromEnum(name: AnalyticsUserPropName.email, value: username),
    );
    Sentry.configureScope((scope) => scope.setUser(SentryUser(id: userId, email: username)));
  }

  @action
  Future<void> logout({bool invalidateRemotely = true}) async {
    logoutFeature = ObservableFuture(_authService.logout(invalidateRemotely: invalidateRemotely));

    await logoutFeature;
  }

  @action
  Future<String?> signInwithEmail({required String email}) async {
    _pkcePair = PkcePair.generate();
    await _flow.savePkcePair(
      codeChallenge: _pkcePair!.codeChallenge,
      codeVerifier: _pkcePair!.codeVerifier,
    );
    try {
      _authenticatingType = GrantType.email;
      signInFeature = ObservableFuture(
        _authService.signInWithEmail(email: email, pkcePair: _pkcePair!),
      );
      final code = await signInFeature;
      if (code != null) {
        authenticate(
          GrantType.email,
          _authService.signInComplete(
            tokenRequest: TokenRequest(
              deviceId: await _deviceIDStore.deviceIdFuture,
              grantType: GrantType.email,
              code: code,
              codeVerifier: _pkcePair!.codeVerifier,
            ),
          ),
        );
      }
      this.email = email;
      return code;
    } catch (e) {
      _emitError(
        e is ApiException ? AuthError(AuthErrorType.serverMessage, e.message) : AuthError.generic,
      );

      rethrow;
    }
  }

  @action
  Future<void> signInWithGoogle() async {
    try {
      _authenticatingType = GrantType.google;
      signInFeature = ObservableFuture(_authService.signInWithGoogle());
      final code = await signInFeature;
      if (code != null) {
        authenticate(
          GrantType.google,
          _authService.signInComplete(
            tokenRequest: TokenRequest(
              deviceId: await _deviceIDStore.deviceIdFuture,
              grantType: GrantType.google,
              googleIdToken: code,
            ),
          ),
        );
      }
    } catch (e) {
      _emitError(
        e is SignInAborted ? const AuthError(AuthErrorType.signInAborted) : AuthError.generic,
      );

      rethrow;
    }
  }

  @action
  Future<void> signInWithApple() async {
    try {
      _authenticatingType = GrantType.apple;
      signInFeature = ObservableFuture(_authService.signInWithApple());
      final code = await signInFeature;
      if (code != null) {
        authenticate(
          GrantType.apple,
          _authService.signInComplete(
            tokenRequest: TokenRequest(
              deviceId: await _deviceIDStore.deviceIdFuture,
              grantType: GrantType.apple,
              authorization: code,
            ),
          ),
        );
      }
    } catch (e) {
      _emitError(
        e is NotAvailableException
            ? const AuthError(AuthErrorType.notAvailable)
            : e is SignInAborted
            ? const AuthError(AuthErrorType.signInAborted)
            : AuthError.generic,
      );

      rethrow;
    }
  }

  @action
  Future<void> loginDesktop() async {
    _pkcePair = PkcePair.generate();
    _flow.savePkcePair(
      codeChallenge: _pkcePair!.codeChallenge,
      codeVerifier: _pkcePair!.codeVerifier,
    );
    final authUri = Uri(
      scheme: 'https',
      host: Env.webAppUrl,
      path: '/oauth/authorize',
      queryParameters: {
        'client_id': 'app',
        'response_type': 'code',
        'code_challenge': _pkcePair!.codeChallenge,
        'code_challenge_method': 's256',
      },
    );
    await openUrlLink(authUri, source: RedirectSource.login);
    return;
  }

  Future<void> deleteAccount() async {
    try {
      deleteAccountFeature = ObservableFuture(_authService.deleteAccount());

      await deleteAccountFeature;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// True while a refresh ended without a verdict from the server.
  bool _refreshInconclusive = false;

  /// Only the OAuth refusal codes mean the refresh token is dead.
  bool _isSessionRejected(Object error) {
    if (error is RefreshTokenNotFoundException) {
      return true;
    }
    final status = error is ApiException ? error.response?.statusCode : null;
    return status == 400 || status == 401;
  }

  Future<void> refreshAuthToken() async {
    _refreshInconclusive = false;
    final TokenResponse authTokens;
    try {
      // A null in memory can be a refused read, so storage gets the last word.
      final refreshToken =
          await _authSessionStore.refreshTokenFuture ?? await _session.refreshTokenOrFail();
      if (refreshToken == null) {
        throw RefreshTokenNotFoundException();
      }

      authTokens = await _authService.signInComplete(
        tokenRequest: TokenRequest(
          deviceId: await _deviceIDStore.deviceIdFuture,
          grantType: GrantType.refreshToken,
          refreshToken: refreshToken,
        ),
      );
    } catch (e) {
      if (!_isSessionRejected(e)) {
        // Unproven, not over: ending it here turned a flaky network into a logout.
        _refreshInconclusive = true;
        _logger.warning('Token refresh did not reach the server: $e');
        rethrow;
      }
      final authState = _authSessionStore.status;
      if (authState == AuthStatus.authenticated) {
        _emitError(const AuthError(AuthErrorType.sessionExpired));
      }
      await logout(invalidateRemotely: false);

      rethrow;
    }

    try {
      await _authSessionStore.setAuthenticated(authTokens.accessToken, authTokens.refreshToken);
    } catch (e) {
      // Already in memory, so an unwritable keychain is not an expired session.
      _logger.warning('Could not persist refreshed credentials: $e');
    }
  }
}

String? _getMagicLinkCode(String query) {
  if (!query.contains('code=') ||
      !query.substring(query.indexOf('code=') + 5, query.length).isUUID()) {
    return null;
  }
  return query.substring(query.indexOf('code=') + 5, query.length);
}
