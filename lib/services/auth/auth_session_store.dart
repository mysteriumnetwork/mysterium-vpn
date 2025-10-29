import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

// Include generated file
part 'auth_session_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthSessionStore = _AuthSessionStore with _$AuthSessionStore;

abstract class _AuthSessionStore with Store, Disposeable {
  _AuthSessionStore({
    required SecureStorageService secureStorage,
    required RemoteConfigStore remoteConfigStore,
  })  : _secureStorage = secureStorage,
        _remoteConfigStore = remoteConfigStore {
    _userReactionDisposer = reaction(
      (_) => user,
      (user) {
        if (user != null) {
          _localDb.setUser(user);
        } else {
          _localDb.clearUser();
        }
      },
      fireImmediately: true,
    );
  }

  final SecureStorageService _secureStorage;
  final RemoteConfigStore _remoteConfigStore;
  final LocalDBService _localDb = LocalDBService.instance;
  late final ReactionDisposer _userReactionDisposer;

  @observable
  AuthStatus status = AuthStatus.unknown;

  @observable
  bool authShown = false;

  @readonly
  late ObservableFuture<String?> _accessTokenFuture = ObservableFuture(
    _secureStorage.getAccessToken(),
  );

  @readonly
  late ObservableFuture<String?> _refreshTokenFuture = ObservableFuture(
    _secureStorage.getRefreshToken(),
  );

  @readonly
  late ObservableFuture<AuthUser?> _userFuture = ObservableFuture(_loadUser());

  @computed
  String? get accessToken => _accessTokenFuture.value;

  @computed
  String? get refreshToken => _refreshTokenFuture.value;

  @computed
  AuthUser? get user => _userFuture.value;

  @computed
  bool get canBrowseApp =>
      status == AuthStatus.authenticated || (authShown && _remoteConfigStore.browseUnauthenticated);

  @action
  Future<void> initStore() async {
    final [accessToken, refreshToken, user] = await Future.wait([
      _accessTokenFuture,
      _refreshTokenFuture,
      _userFuture,
    ]);
    status = accessToken != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  @action
  Future<void> setAuthenticated(String accessToken, String? refreshToken) async {
    _accessTokenFuture = ObservableFuture.value(accessToken);
    _refreshTokenFuture = ObservableFuture.value(refreshToken);
    status = AuthStatus.authenticated;

    await _storageUpdate();
  }

  @action
  Future<void> setAuthenticatedUser(AuthUser user) async {
    _userFuture = ObservableFuture.value(user);
    await _userFuture;
    await _storageUpdate();
  }

  @action
  Future<void> setUnauthenticated() async {
    _accessTokenFuture = ObservableFuture.value(null);
    _refreshTokenFuture = ObservableFuture.value(null);
    status = AuthStatus.unauthenticated;
    _userFuture = ObservableFuture.value(null);
    authShown = false;

    await _storageCleanup();
  }

  Future<AuthUser?> _loadUser() async {
    final [userId, userEmail] = await Future.wait([
      _secureStorage.getUserId(),
      _secureStorage.getUsername(),
    ]);

    if (userId != null && userEmail != null) {
      return AuthUser(userId: userId, username: userEmail);
    }
    return null;
  }

  Future<void> _storageUpdate() async {
    if (accessToken != null) {
      await _secureStorage.saveAccessToken(accessToken!);
    }
    if (refreshToken != null) {
      await _secureStorage.saveRefreshToken(refreshToken!);
    }
    if (user != null) {
      await _secureStorage.saveUserId(userId: user!.userId);
      await _secureStorage.saveUsername(username: user!.username);
    }
  }

  Future<void> _storageCleanup() async {
    await _secureStorage.removeAccessToken();
    await _secureStorage.removeRefreshToken();
    await _secureStorage.removeUserId();
    await _secureStorage.removeUsername();
  }

  Future<void> invalidateAccessToken() async {
    _accessTokenFuture = _accessTokenFuture.replace(() async {
      await _secureStorage.saveAccessToken('invalid');
      return _secureStorage.getAccessToken();
    }());
    await _accessTokenFuture;
  }

  @override
  void dispose() {
    _userReactionDisposer();
  }
}
