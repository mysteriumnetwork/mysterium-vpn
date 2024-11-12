import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';

// Include generated file
part 'auth_session_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthSessionStore = _AuthSessionStore with _$AuthSessionStore;

abstract class _AuthSessionStore with Store {
  _AuthSessionStore({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage {
    _storageLoad();
  }

  final SecureStorageService _secureStorage;

  @readonly
  String? _accessToken;

  @readonly
  String? _refreshToken;

  @action
  void login(String accessToken, String? refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    _storageUpdate();
  }

  @action
  void logout() {
    _accessToken = null;
    _refreshToken = null;

    _storageCleanup();
  }

  Future<void> _storageLoad() async {
    await _secureStorage.getAccessToken().then((value) async {
      _accessToken = value;
    });
    await _secureStorage.getRefreshToken().then((value) async {
      _refreshToken = value;
    });
  }

  Future<void> _storageUpdate() async {
    if (_accessToken != null) {
      await _secureStorage.saveAccessToken(_accessToken!);
    }
    if (_refreshToken != null) {
      await _secureStorage.saveRefreshToken(_refreshToken!);
    }
  }

  Future<void> _storageCleanup() async {
    await _secureStorage.removeAccessToken();
    await _secureStorage.removeRefreshToken();
  }
}
