import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';

// Include generated file
part 'auth_session_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthSessionStore = _AuthSessionStore with _$AuthSessionStore;

abstract class _AuthSessionStore with Store {
  _AuthSessionStore({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  final SecureStorageService _secureStorage;

  @observable
  AuthStatus status = AuthStatus.unknown;

  @readonly
  String? _accessToken;

  @readonly
  String? _refreshToken;

  @readonly
  AuthUser? _user;

  @action
  Future<void> initStore() async {
    await _storageLoad();
  }

  @action
  void setAuthenticated(String accessToken, String? refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    _storageUpdate();
  }

  @action
  void setAuthenticatedUser(AuthUser user) {
    _user = user;

    _storageUpdate();
  }

  @action
  void setUnauthenticated() {
    _accessToken = null;
    _refreshToken = null;
    _user = null;

    _storageCleanup();
  }

  Future<void> _storageLoad() async {
    _accessToken = await _secureStorage.getAccessToken();
    _refreshToken = await _secureStorage.getRefreshToken();
  }

  Future<void> _storageUpdate() async {
    if (_accessToken != null) {
      await _secureStorage.saveAccessToken(_accessToken!);
    }
    if (_refreshToken != null) {
      await _secureStorage.saveRefreshToken(_refreshToken!);
    }
    if (_user != null) {
      await _secureStorage.saveUserId(userId: _user!.userId);
      await _secureStorage.saveUsername(username: _user!.username);
    }
  }

  Future<void> _storageCleanup() async {
    await _secureStorage.removeAccessToken();
    await _secureStorage.removeRefreshToken();
    await _secureStorage.removeUserId();
    await _secureStorage.removeUsername();
  }
}
