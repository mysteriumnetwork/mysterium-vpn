import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/auth_status.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:talker/talker.dart';

part 'refresh_ip_store.g.dart';

const _initialRefreshIPConnectionValue = true;
// ignore: library_private_types_in_public_api
class RefreshIPStore = _RefreshIPStore with _$RefreshIPStore;

abstract class _RefreshIPStore with Store {
  _RefreshIPStore(this._localDBService, this._logger, this._authSessionStore) {
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
  ObservableFuture<bool> refreshIPFuture = ObservableFuture.value(_initialRefreshIPConnectionValue);

  @computed
  bool get refreshIPConnection => refreshIPFuture.value ?? _initialRefreshIPConnectionValue;

  @action
  Future<bool> getRefreshIPConnection() =>
      refreshIPFuture = ObservableFuture(_getAndSetRefreshIPConnection());

  @action
  Future<bool> _getAndSetRefreshIPConnection() async {
    try {
      return await _localDBService.getRefreshIPConnection();
    } catch (e) {
      _logger.handle(e);
      return true;
    }
  }

  @action
  Future<void> toggleRefreshIPWhenConnecting() async {
    try {
      await _localDBService.setRefreshIPConnection(refreshIPConnection: !refreshIPConnection);
      refreshIPFuture = ObservableFuture.value(!refreshIPConnection);
    } catch (e) {
      _logger.handle(e);
    }
  }

  void disposeStore() {
    _authReactionDisposer?.call();
  }
}
