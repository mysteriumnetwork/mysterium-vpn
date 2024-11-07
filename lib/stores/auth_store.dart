// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/store_not_available.dart';
import 'package:mysterium_vpn/common/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/models/token_request.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';
import 'package:mysterium_vpn/stores/remote_config/ab_testing_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

// Project imports:

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore({
    required AuthService authService,
    required AppLinks appLinks,
    required LocalDBService localDb,
    required AnalyticsStore analyticsStore,
    required FlavorConfig env,
    required IntercomStore intercomStore,
    required Talker logger,
    required UserPreferencesStore userPreferencesStore,
    required RemoteConfigStore remoteConfigStore,
    required ABTestingStore abTestingStore,
  })  : _authService = authService,
        _appLinks = appLinks,
        _localDb = localDb,
        _analyticsStore = analyticsStore,
        _env = env,
        _intercomStore = intercomStore,
        _logger = logger,
        _userPreferencesStore = userPreferencesStore,
        _remoteConfigStore = remoteConfigStore,
        _abTestingStore = abTestingStore {
    initAuth();
    refreshTokenCallback = refreshAuthToken;
  }

  final AuthService _authService;
  final LocalDBService _localDb;
  final AppLinks _appLinks;
  final SecureStorageService _secureStorageService = SecureStorageService.instance;
  final AnalyticsStore _analyticsStore;
  final FlavorConfig _env;
  final IntercomStore _intercomStore;
  final Talker _logger;
  final UserPreferencesStore _userPreferencesStore;
  final RemoteConfigStore _remoteConfigStore;
  final ABTestingStore _abTestingStore;

  @readonly
  AuthStatus _authStatus = AuthStatus.unknown;

  @readonly
  PkcePair? _pkcePair;

  @readonly
  GrantType? _authenticatingType;

  @observable
  String? email;

  @observable
  String? temporaryEmail;

  @readonly
  AuthData? _authData;

  @observable
  bool marketingConsent = true;

  @observable
  ObservableFuture<String?> signInFeatureFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<void> logoutFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<void> deleteAccountFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<AuthData?> authenticateFeature = ObservableFuture.value(null);

  @action
  Future<void> initAuth() async {
    try {
      _pkcePair = await _secureStorageService.getPkcePair();
      email = await _secureStorageService.getLastLoggedInUser();
      temporaryEmail = email;
      final appLink = await _appLinks.getLatestLink();
      final storedLink = await _secureStorageService.getAppLink();
      if (appLink != null && appLink.toString() != storedLink) {
        await _secureStorageService.saveAppLink(appLink: appLink.toString());
        verifyMagicLinkAndAuthenticate(appLink);
      } else {
        authenticate(GrantType.savedToken, _authService.checkUserAuth());
      }
      _appLinks.uriLinkStream.listen(
        (appLink) async {
          if (_authStatus == AuthStatus.authenticated) {
            return;
          }
          final storedLink = await _secureStorageService.getAppLink();
          if (appLink.toString() != storedLink) {
            await _secureStorageService.saveAppLink(appLink: appLink.toString());
            verifyMagicLinkAndAuthenticate(appLink);
          } else {
            Sentry.captureException(TokenAlreadyUsedException());
            showSnackbar(LocaleKeys.tokenAlreadyUsed.tr());
          }
        },
      );
    } catch (e) {
      _logger.handle(e);
      _authStatus = AuthStatus.unauthenticated;
    }
  }

  void verifyMagicLinkAndAuthenticate(Uri appLink) {
    try {
      if (appLink.query.isEmpty) {
        throw IncorrectMagicLinkException();
      }
      final code = getMagicLinkCode(appLink.query);
      if (code == null || _pkcePair == null) {
        throw IncorrectCodeException();
      }
      authenticate(
        GrantType.email,
        _authService.singInComplete(
          tokenRequest: TokenRequest(
            grantType: GrantType.email,
            code: code,
            codeVerifier: _pkcePair!.codeVerifier,
          ),
        ),
      );
    } catch (e) {
      showSnackbar(LocaleKeys.incorrectMagicLink.tr());
      rethrow;
    }
  }

  @action
  Future<void> authenticate(
    GrantType grantType,
    Future<AuthData?> authenticateFeature,
  ) async {
    try {
      if (_authStatus == AuthStatus.authenticating) {
        return;
      }
      _authStatus = AuthStatus.authenticating;

      final res = await authenticateFeature;
      await _localDb.setUserId(res!.username);
      _initializeAnalyticsStores(username: res.username, userId: res.userId, grantType: grantType);
      _authData = res;
      _authStatus = AuthStatus.authenticated;
      _logger.info(_localDb.userData.toString());
      if (grantType != GrantType.savedToken) {
        Future.delayed(
          const Duration(seconds: 5),
          () => _userPreferencesStore.setEmailMarketingConsent(consent: marketingConsent),
        );
      }
    } catch (e) {
      _authStatus = AuthStatus.unauthenticated;
      if (e is KeyDoesntExistsException || e is AuthenticationRequiredException) {
        _logger.info('User token expired or not found');
        return;
      }
      var message = LocaleKeys.authenticationFailed.tr();
      if (e is ApiException) {
        message = e.message;
      }
      showSnackbar(message);
    }
  }

  Future<void> _initializeAnalyticsStores({
    required String username,
    required String userId,
    required GrantType grantType,
  }) async {
    if (grantType != GrantType.savedToken) {
      _analyticsStore.setLogin(grantType);
    }
    await _remoteConfigStore.setDefaultUser(email: username, userId: userId);
    await _abTestingStore.setDefaultUser(email: username, userId: userId);
    _analyticsStore.setUserId(username);
    _intercomStore.registerUser(email: username);
    Sentry.configureScope(
      (scope) => scope.setUser(
        SentryUser(
          id: userId,
          email: username,
        ),
      ),
    );
  }

  @action
  Future<void> logout({
    String? email,
  }) async {
    logoutFeature = ObservableFuture(_authService.logout());

    await logoutFeature;
    _intercomStore.logout();
    _authStatus = AuthStatus.unauthenticated;
    _authData = null;
    temporaryEmail = email;
  }

  @action
  Future<void> logoutFromAllDevices() async {
    try {
      await _authService.disconnectAllDevices();
      await logout();
    } catch (e) {
      showSnackbar(LocaleKeys.failedToLogoutAllDevices.tr());
    }
  }

  @action
  Future<String?> signInwithEmail({required String email}) async {
    _pkcePair = PkcePair.generate();
    _secureStorageService.savePkcePair(
      codeChallenge: _pkcePair!.codeChallenge,
      codeVerifier: _pkcePair!.codeVerifier,
    );
    try {
      _authenticatingType = GrantType.email;
      signInFeatureFeature = ObservableFuture(
        _authService.signInWithEmail(
          email: email,
          pkcePair: _pkcePair!,
        ),
      );
      final code = await signInFeatureFeature;
      if (code != null) {
        authenticate(
          GrantType.email,
          _authService.singInComplete(
            tokenRequest: TokenRequest(
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
      signInFeatureFeature = ObservableFuture(
        _authService.signInWithGoogle(),
      );
      final code = await signInFeatureFeature;
      if (code != null) {
        authenticate(
          GrantType.google,
          _authService.singInComplete(
            tokenRequest: TokenRequest(
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
      signInFeatureFeature = ObservableFuture(
        _authService.signInWithApple(),
      );
      final code = await signInFeatureFeature;
      if (code != null) {
        authenticate(
          GrantType.apple,
          _authService.singInComplete(
            tokenRequest: TokenRequest(
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
      host: _env.values.webAppUrl,
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
      deleteAccountFeature = ObservableFuture(
        _authService.deleteAccount(email: _authData?.username ?? ''),
      );

      await deleteAccountFeature;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> refreshAuthToken() async {
    try {
      final refreshToken = await _secureStorageService.getRefreshToken();
      final authDta = await _authService.singInComplete(
          tokenRequest: TokenRequest(
          grantType: GrantType.refreshToken,
          refreshToken: refreshToken,
        ),
      );

      return authDta.accessToken;
    } catch (e) {
      showSnackbar(LocaleKeys.loginSessionExpired.tr());
      await logout();

      rethrow;
    }
  }
}
