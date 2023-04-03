// Flutter imports:
// Package imports:
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/wrong_auth_token.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/auth_data.dart';
import 'package:mysterium_vpn/services/auth/auth_service.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';

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
  String _email = '';

  @readonly
  AuthData? _authData;

  @observable
  ObservableFuture<void> loginFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<void> logoutFeature = ObservableFuture.value(null);
  @observable
  ObservableFuture<AuthData?> authenticateFeature = ObservableFuture.value(null);

  @action
  Future<void> initAuth() async {
    try {
      final appLink = await _appLinks.getLatestAppLink();
      final storedLink = await _secureStorageService.getAppLink();
      if (appLink != null && appLink.toString() != storedLink) {
        await _secureStorageService.saveAppLink(appLink: appLink.toString());
        authenticate(appLink);
      } else {
        authenticate(null);
      }
      _appLinks.uriLinkStream.listen(
        (appLink) async {
          final storedLink = await _secureStorageService.getAppLink();
          if (appLink.toString() != storedLink) {
            await _secureStorageService.saveAppLink(appLink: appLink.toString());
            authenticate(appLink);
          }
        },
      );
    } catch (e) {
      showSnackbar('Error while initializing authentication.Please give it another try. 😕');
      debugPrint(e.toString());
    }
  }

  @action
  Future<void> authenticate(Uri? appLink) async {
    try {
      if (_authStatus == AuthStatus.authenticating) {
        return;
      }

      _authStatus = AuthStatus.authenticating;
      if (appLink != null) {
        if (appLink.pathSegments.length != 2 || !appLink.pathSegments[1].isUUID()) {
          throw WrongAuthTokenException();
        }
        authenticateFeature = ObservableFuture(
          _authService.completeLogin(authToken: appLink.pathSegments[1]),
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
    } catch (e) {
      showSnackbar('Error while authenticating. Please give it another try. 😕');
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
  Future<void> login({required String email}) async {
    loginFeature = ObservableFuture(_authService.login(email: email));
    await loginFeature;
    _email = email;
  }
}
