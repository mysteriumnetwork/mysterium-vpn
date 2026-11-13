import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
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
    this._settings,
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

  final ConnectionSettingsRepository _settings;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  ReactionDisposer? _authReactionDisposer;
  final AuthSessionStore _authSessionStore;

  @visibleForTesting
  bool testIsIOS = false;

  @visibleForTesting
  bool testIsMacOS = false;

  @visibleForTesting
  bool testIsAndroid = false;

  @visibleForTesting
  bool testIsWindows = false;

  /// When any `testIsX` is set, host `Platform` is ignored.
  bool get _useTestPlatform => testIsIOS || testIsMacOS || testIsAndroid || testIsWindows;

  bool get _isApple =>
      _useTestPlatform ? testIsIOS || testIsMacOS : Platform.isIOS || Platform.isMacOS;

  /// VLESS ships only on iOS and macOS, and only once the flag is on. Picking
  /// it anywhere else reaches a plugin that has no implementation.
  bool _isAvailable(ProtocolType protocol) => switch (protocol) {
    ProtocolType.wireguard || ProtocolType.openvpn => true,
    ProtocolType.vless => _isApple && _remoteConfigStore.vlessEnabled,
  };

  /// What the picker should offer. Always contains [_defaultProtocol].
  @computed
  List<ProtocolType> get availableProtocols => ProtocolType.values.where(_isAvailable).toList();

  @observable
  ObservableFuture<ProtocolType> protocolFuture = ObservableFuture.value(_defaultProtocol);

  @computed
  ProtocolType get protocol {
    final selected = protocolFuture.value ?? _defaultProtocol;
    // The stored choice outlives the gates that allowed it. Without this a flag
    // turned off mid-session leaves VpnStore on VLESS and hands the picker a
    // value that is no longer in [availableProtocols].
    return _isAvailable(selected) ? selected : _defaultProtocol;
  }

  // Enabled via remote config
  @computed
  bool get isProtocolPickerAvailable => _remoteConfigStore.isProtocolPickerAvailable;

  @action
  Future<ProtocolType> getProtocol() async {
    try {
      if (!_remoteConfigStore.isProtocolPickerAvailable) {
        return _defaultProtocol;
      }
      final stored = await _settings.protocolType();
      // The flag is a kill switch: a user left on VLESS when it is turned off,
      // or restoring a backup onto another platform, falls back instead of
      // reaching a tunnel that is not there.
      final protocol = _isAvailable(stored) ? stored : _defaultProtocol;
      _analyticsStore.setUserProperty(
        AnalyticsUserProperty.fromEnum(name: AnalyticsUserPropName.protocol, value: protocol.name),
      );
      return protocol;
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': defaultTargetPlatform.name,
          'hint': 'Failed to get protocol from local DB',
        }),
      );
      return _defaultProtocol;
    }
  }

  @action
  Future<void> setProtocol(ProtocolType newProtocol) async {
    if (!_remoteConfigStore.isProtocolPickerAvailable || !_isAvailable(newProtocol)) {
      return;
    }
    try {
      protocolFuture = ObservableFuture.value(newProtocol);
      await _settings.setProtocolType(newProtocol);
      _analyticsStore.logEvent(
        AnalyticsEvent.changeProtocolType,
        parameters: {'protocol': newProtocol.name},
      );
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': defaultTargetPlatform.name,
          'hint': 'Failed to set protocol in local DB',
        }),
      );
      _analyticsStore.logEvent(
        AnalyticsEvent.changeProtocolTypeError,
        parameters: {'error': e.toString(), 'protocol': newProtocol.name},
      );
      rethrow;
    }
  }

  // Call on log out or app termiantion
  Future<void> disposeStore() async {
    _authReactionDisposer?.call();
  }
}
