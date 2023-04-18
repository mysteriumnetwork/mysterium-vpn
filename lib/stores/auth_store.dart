// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/models/pkce.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore({
    required AuthService authService,
    required AppLinks appLinks,
    required LocalDBService localDb,
  })  : _authService = authService,
        _appLinks = appLinks,
        _localDb = localDb {
    initAuth();
  }

  final AuthService _authService;
  final LocalDBService _localDb;
  final AppLinks _appLinks;
  final SecureStorageService _secureStorageService = SecureStorageService();

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
            showSnackbar('Token already used. Please try again. 😕');
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
      _authData = await authenticateFeature;
      _authStatus = AuthStatus.authenticated;
      _localDb.setUserId(_authData!.userId);
      debugPrint(_localDb.userData.toString());
    } on KeyDoesntExistsException {
      _authStatus = AuthStatus.unauthenticated;
    } catch (e) {
      if (e is IncorrectMagicLinkException) {
        showSnackbar('Incorrect magic link. Please try again. 😕');
      } else if (e is IncorrectCodeException) {
        showSnackbar('Incorrect code. Please try again. 😕');
      } else {
        showSnackbar('Error while authenticating. Please give it another try. 😕');
      }
      debugPrint(e.toString());
      _authStatus = AuthStatus.unauthenticated;
    }
  }

  @action
  Future<void> logout() async {
    logoutFeature = ObservableFuture(_authService.logout());

    await logoutFeature;
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
    if (code != null) {
      authenticate(code: code);
    }
    _email = email;
    return code;
  }
}
