// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics_store.dart';
import 'package:mysterium_vpn/stores/intercom_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  })  : _authService = authService,
        _appLinks = appLinks,
        _localDb = localDb,
        _analyticsStore = analyticsStore,
        _env = env,
        _intercomStore = intercomStore {
    initAuth();
  }

  final AuthService _authService;
  final LocalDBService _localDb;
  final AppLinks _appLinks;
  final SecureStorageService _secureStorageService = SecureStorageService();
  final AnalyticsStore _analyticsStore;
  final FlavorConfig _env;
  final IntercomStore _intercomStore;

  @readonly
  AuthStatus _authStatus = AuthStatus.unknown;

  @readonly
  PkcePair? _pkcePair;

  @readonly
  String _email = '';

  @readonly
  AuthData? _authData;

  @observable
  ObservableFuture<String?> loginFeature = ObservableFuture.value(null);
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
      final appLink = await _appLinks.getLatestAppLink();
      final storedLink = await _secureStorageService.getAppLink();
      if (appLink != null && appLink.toString() != storedLink) {
        await _secureStorageService.saveAppLink(appLink: appLink.toString());
        authenticate(appLink: appLink);
      } else {
        authenticate();
      }
      _appLinks.uriLinkStream.listen(
        (appLink) async {
          final storedLink = await _secureStorageService.getAppLink();
          if (appLink.toString() != storedLink) {
            await _secureStorageService.saveAppLink(appLink: appLink.toString());
            authenticate(appLink: appLink);
          } else {
            Sentry.captureException(TokenAlreadyUsedException());
            showSnackbar(LocaleKeys.tokenAlreadyUsed.tr());
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @action
  Future<void> authenticate({
    Uri? appLink,
    String? code,
  }) async {
    try {
      if (_authStatus == AuthStatus.authenticating) {
        return;
      }
      if (appLink != null) {
        _authStatus = AuthStatus.authenticating;
        if (appLink.query.isEmpty) {
          throw IncorrectMagicLinkException();
        }
        final code = getMagicLinkCode(appLink.query);
        if (code == null) {
          throw IncorrectCodeException();
        }
        authenticateFeature = ObservableFuture(
          _authService.completeLogin(
            authToken: code,
            pkcePair: _pkcePair!,
          ),
        );
      } else if (code != null) {
        _authStatus = AuthStatus.authenticating;
        authenticateFeature = ObservableFuture(
          _authService.completeLogin(
            authToken: code,
            pkcePair: _pkcePair!,
          ),
        );
      } else {
        authenticateFeature = ObservableFuture(
          _authService.checkUserAuth(),
        );
      }
      final res = await authenticateFeature;

      await _localDb.setUserId(res!.username);
      _analyticsStore
        ..setUserId(res.username)
        ..setLogin();
      _intercomStore.registerUser(email: res.username);
      FirebaseCrashlytics.instance.setUserIdentifier(res.username);
      Sentry.configureScope(
        (scope) => scope.setUser(
          SentryUser(
            id: res.userId,
            email: res.username,
          ),
        ),
      );
      _authData = res;
      _authStatus = AuthStatus.authenticated;
      debugPrint(_localDb.userData.toString());
    } on KeyDoesntExistsException {
      _authStatus = AuthStatus.unauthenticated;
    } catch (e) {
      if (e is IncorrectMagicLinkException) {
        showSnackbar(LocaleKeys.incorrectMagicLink.tr());
      } else if (e is IncorrectCodeException) {
        showSnackbar(LocaleKeys.incorrectMagicLink.tr());
      } else {
        showSnackbar(LocaleKeys.authenticationFailed.tr());
      }
      debugPrint(e.toString());
      _authStatus = AuthStatus.unauthenticated;
    }
  }

  @action
  Future<void> logout() async {
    logoutFeature = ObservableFuture(_authService.logout());

    await logoutFeature;
    _analyticsStore.setLogOut(_authData?.username ?? '');
    _intercomStore.logout();
    _authStatus = AuthStatus.unauthenticated;
    _authData = null;
  }

  @action
  Future<String?> login({required String email}) async {
    _pkcePair = PkcePair.generate();
    _secureStorageService.savePkcePair(
      codeChallenge: _pkcePair!.codeChallenge,
      codeVerifier: _pkcePair!.codeVerifier,
    );
    loginFeature = ObservableFuture(
      _authService.login(
        email: email,
        pkcePair: _pkcePair!,
      ),
    );
    final code = await loginFeature;
    _analyticsStore.setSignUp(email);
    if (code != null) {
      authenticate(code: code);
    }
    _email = email;
    return code;
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
    await launchUrl(authUri);
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
}
