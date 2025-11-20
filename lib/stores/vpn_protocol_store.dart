import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'vpn_protocol_store.g.dart';

const _defaultProtocol = ProtocolType.wireguard;

// ignore: library_private_types_in_public_api
class VpnProtocolStore = _VpnProtocolStore with _$VpnProtocolStore;

abstract class _VpnProtocolStore with Store {
  _VpnProtocolStore(
    this._localDB,
    this._analyticsStore,
    this._remoteConfigStore,
    this._authSessionStore,
  ) {
    _authReactionDisposer = reaction<AuthStatus>(
      (_) => _authSessionStore.status,
      (status) async {
        if (status == AuthStatus.authenticated) {
          protocolFuture = ObservableFuture(getProtocol());
        }
      },
      fireImmediately: true,
      equals: (p0, p1) => p0?.name == p1?.name,
    );
  }

  final LocalDBService _localDB;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  ReactionDisposer? _authReactionDisposer;
  final AuthSessionStore _authSessionStore;

  @observable
  ObservableFuture<ProtocolType> protocolFuture = ObservableFuture.value(_defaultProtocol);

  @computed
  ProtocolType get protocol => protocolFuture.value ?? _defaultProtocol;

  @action
  Future<ProtocolType> getProtocol() async {
    try {
      if (!_remoteConfigStore.isProtocolPickerAvailable) {
        return _defaultProtocol;
      }
      return await _localDB.getProtocolType();
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap(
          {
            'platform': defaultTargetPlatform.name,
            'hint': 'Failed to get protocol from local DB',
          },
        ),
      );
      return _defaultProtocol;
    }
  }

  @action
  Future<void> setProtocol(ProtocolType newProtocol) async {
    if (!_remoteConfigStore.isProtocolPickerAvailable) {
      return;
    }
    try {
      protocolFuture = ObservableFuture.value(newProtocol);
      await _localDB.setProtocolType(newProtocol);
      _analyticsStore
          .logEvent(AnalyticsEvent.changeProtocolType, parameters: {'protocol': newProtocol.name});
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap(
          {
            'platform': defaultTargetPlatform.name,
            'hint': 'Failed to set protocol in local DB',
          },
        ),
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.changeProtocolTypeError,
        parameters: {
          'error': e.toString(),
          'protocol': newProtocol.name,
        },
      );
      rethrow;
    }
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _authReactionDisposer?.call();
  }
}
