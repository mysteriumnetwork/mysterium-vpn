import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

// Include generated file
part 'auth_session_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthSessionStore = _AuthSessionStore with _$AuthSessionStore implements AuthSessionGateway;

abstract class _AuthSessionStore with Store, Disposeable {
  _AuthSessionStore({
    required SessionRepository repository,
    required RemoteConfigStore remoteConfigStore,
  }) : _repository = repository,
       _remoteConfigStore = remoteConfigStore {
    _userReactionDisposer = reaction(
      (_) => user,
      _repository.cacheUserRecord,
      fireImmediately: true,
    );
  }

  final SessionRepository _repository;
  final RemoteConfigStore _remoteConfigStore;
  late final ReactionDisposer _userReactionDisposer;

  @observable
  AuthStatus status = AuthStatus.unknown;

  @observable
  bool authShown = false;

  @computed
  bool get isAuthenticated => status == AuthStatus.authenticated;

  @readonly
  late ObservableFuture<String?> _accessTokenFuture = ObservableFuture(_repository.accessToken());

  @readonly
  late ObservableFuture<String?> _refreshTokenFuture = ObservableFuture(_repository.refreshToken());

  @readonly
  late ObservableFuture<AuthUser?> _userFuture = ObservableFuture(_repository.user());

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

  Future<void> _storageUpdate() =>
      _repository.save(accessToken: accessToken, refreshToken: refreshToken, user: user);

  Future<void> _storageCleanup() => _repository.clear();

  Future<void> invalidateAccessToken() async {
    _accessTokenFuture = _accessTokenFuture.replace(_repository.corruptAccessToken());
    await _accessTokenFuture;
  }

  @override
  void dispose() {
    _userReactionDisposer();
  }
}
