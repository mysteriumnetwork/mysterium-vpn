// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/core/device/device_id_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

// Project imports:

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore({
    required AuthService authService,
    required AuthSessionStore authSessionStore,
    required AppLinks appLinks,
    required AnalyticsStore analyticsStore,
    required Talker logger,
    required ABTestingStore abTestingStore,
    required DeviceIDStore deviceIDStore,
  }) : _authService = authService,
       _authSessionStore = authSessionStore,
       _appLinks = appLinks,
       _analyticsStore = analyticsStore,
       _logger = logger,
       _abTestingStore = abTestingStore,
       _deviceIDStore = deviceIDStore {
    refreshTokenCallback = refreshAuthToken;
  }

  final AuthService _authService;
  final AuthSessionStore _authSessionStore;
  final LocalDBService _localDb = LocalDBService.instance;
  final AppLinks _appLinks;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
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
  Future<String?> getLastLoggedInUser() async =>
      email ?? await _secureStorageService.getLastLoggedInUser();

  @action
  Future<void> initAuth() async {
    try {
      email = await _secureStorageService.getLastLoggedInUser();
      _appLinks.uriLinkStream.listen((appLink) async {
        if (_authSessionStore.isAuthenticated) {
          return;
        }
        final storedLink = await _secureStorageService.getAppLink();
        if (appLink.toString() != storedLink) {
          await _secureStorageService.saveAppLink(appLink: appLink.toString());

          await verifyMagicLinkAndAuthenticate(appLink);
        } else {
          Sentry.captureException(TokenAlreadyUsedException());
          showSnackbar(LocaleKeys.tokenAlreadyUsed.tr());
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
      final code = getMagicLinkCode(appLink.query);
      if (code == null) {
        throw IncorrectCodeException();
      }

      if (_pkcePair == null && (_pkcePair = await _secureStorageService.getPkcePair()) == null) {
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
      showSnackbar(LocaleKeys.incorrectMagicLink.tr());
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
      if (e.code == 401) {
        _logger.error('User AccessToken invalid');
        await _authSessionStore.setUnauthenticated();
        return;
      }

      _logger.handle(e, stackTrace);
      showSnackbar(e.message);
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      showSnackbar(LocaleKeys.authenticationFailed.tr());
    }
  }

  @action
  Future<void> authenticate(GrantType grantType, Future<TokenResponse> feature) async {
    try {
      authenticateFeature = ObservableFuture(feature);
      final authTokens = await authenticateFeature;
      await _authSessionStore.setAuthenticated(authTokens!.accessToken, authTokens.refreshToken);
      _analyticsStore.setLogin(grantType);
    } on ApiException catch (e) {
      showSnackbar(e.message);
    } catch (e) {
      showSnackbar(LocaleKeys.authenticationFailed.tr());
    }
  }

  @action
  Future<void> _initializeAuthenticatedUser(AuthUser user) async {
    await _authSessionStore.setAuthenticatedUser(user);
    _initializeAnalyticsStores(username: user.username, userId: user.userId);

    // Set auth user
    await _localDb.setUser(user);
    final userSettings = await _localDb.getUserData();
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
    await _secureStorageService.savePkcePair(
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
      e is ApiException
          ? showSnackbar(e.message)
          : showSnackbar(LocaleKeys.somethingWentWrong.tr());

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
      e is SignInAborted
          ? showSnackbar('Sign in aborted')
          : showSnackbar(LocaleKeys.somethingWentWrong.tr());

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
      e is NotAvailableException
          ? showSnackbar('Not available')
          : e is SignInAborted
          ? showSnackbar('Sign in aborted')
          : showSnackbar(LocaleKeys.somethingWentWrong.tr());

      rethrow;
    }
  }

  @action
  Future<void> loginDesktop() async {
    _pkcePair = PkcePair.generate();
    _secureStorageService.savePkcePair(
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
    await openUrlLink(authUri);
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

  Future<void> refreshAuthToken() async {
    try {
      final refreshToken = await _authSessionStore.refreshTokenFuture;
      if (refreshToken == null) {
        throw RefreshTokenNotFoundException();
      }

      final authTokens = await _authService.signInComplete(
        tokenRequest: TokenRequest(
          deviceId: await _deviceIDStore.deviceIdFuture,
          grantType: GrantType.refreshToken,
          refreshToken: refreshToken,
        ),
      );
      await _authSessionStore.setAuthenticated(authTokens.accessToken, authTokens.refreshToken);
    } catch (e) {
      final authState = _authSessionStore.status;
      if (authState == AuthStatus.authenticated) {
        showSnackbar(LocaleKeys.loginSessionExpired.tr());
      }
      await logout(invalidateRemotely: false);

      rethrow;
    }
  }
}
