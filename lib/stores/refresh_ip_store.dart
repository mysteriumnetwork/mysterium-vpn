import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:talker/talker.dart';

part 'refresh_ip_store.g.dart';

// ignore: library_private_types_in_public_api
class RefreshIPStore = _RefreshIPStore with _$RefreshIPStore;

abstract class _RefreshIPStore with Store {
  _RefreshIPStore(
    this._localDBService,
    this._logger,
    this._authSessionStore,
  ) {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) {
        if (status == AuthStatus.authenticated) {
          refreshIPFuture = ObservableFuture(getRefreshIPConnection());
        }
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );
  }

  final LocalDBService _localDBService;
  final Talker _logger;
  final AuthSessionStore _authSessionStore;
  ReactionDisposer? _authReactionDisposer;

  @observable
  ObservableFuture<bool> refreshIPFuture = ObservableFuture.value(true);

  @readonly
  bool _refreshIPConnection = true;

  @action
  Future<bool> getRefreshIPConnection() =>
      refreshIPFuture = ObservableFuture(_getAndSetRefreshIPConnection());

  @action
  Future<bool> _getAndSetRefreshIPConnection() async {
    try {
      return _refreshIPConnection = await _localDBService.getRefreshIPConnection();
    } catch (e) {
      _logger.handle(e);
      return true;
    }
  }

  @action
  Future<void> toggleRefreshIPWhenConnecting() async {
    await _localDBService.setRefreshIPConnection(
      refreshIPConnection: !_refreshIPConnection,
    );
    _refreshIPConnection = !_refreshIPConnection;
  }

  void disposeStore() {
    _authReactionDisposer?.call();
  }
}
