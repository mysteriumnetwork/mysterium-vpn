import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/vpn_protocol_store.dart';

part 'udp_blocked_suggestion_store.g.dart';

// ignore: library_private_types_in_public_api
class UdpBlockedSuggestionStore = _UdpBlockedSuggestionStore with _$UdpBlockedSuggestionStore;

/// Decides whether a blocked-UDP result is worth acting on, raises a one-shot
/// notice asking the user to move to OpenVPN (TCP), and owns the whole
/// `dpi_protocol_fallback_*` funnel so it is defined in one place.
abstract class _UdpBlockedSuggestionStore with Store {
  _UdpBlockedSuggestionStore(
    this._remoteConfigStore,
    this._protocolStore,
    this._authSessionStore,
    this._analyticsStore,
  );

  final RemoteConfigStore _remoteConfigStore;
  final VpnProtocolStore _protocolStore;
  final AuthSessionStore _authSessionStore;
  final AnalyticsStore _analyticsStore;

  /// Whether the STUN probe is worth running. False on OpenVPN — that already
  /// runs over TCP, so a blocked-UDP result would carry no action.
  @computed
  bool get shouldRunCheck =>
      _remoteConfigStore.shouldCheckUdp && _protocolStore.protocol == ProtocolType.wireguard;

  /// Mirrors when the settings protocol picker is offered, so the suggestion
  /// can never propose something the user couldn't also do by hand.
  @computed
  bool get isOpenVpnAvailable =>
      _protocolStore.isProtocolPickerAvailable && _authSessionStore.isAuthenticated;

  /// Set when UDP is blocked and OpenVPN is a real option; drives the dialog.
  @observable
  bool suggestOpenVpn = false;

  @action
  void onUdpBlocked(String error) {
    final suggest = isOpenVpnAvailable;
    // Raw detection — logged even when the fallback is unavailable, so the
    // blocked-network rate stays measurable independently of the remote flag.
    _analyticsStore.logEvent(
      AnalyticsEvent.udpBlocked,
      parameters: {'error': error, 'suggested': suggest},
    );
    if (!suggest) {
      return;
    }
    _analyticsStore.logEvent(
      AnalyticsEvent.dpiProtocolFallbackTriggered,
      parameters: {'error': error, 'from_protocol': ProtocolType.wireguard.name},
    );
    suggestOpenVpn = true;
  }

  /// Called by the view once the dialog is shown. Returning to false re-arms
  /// the notice, so the next blocked connection suggests again.
  @action
  void clearSuggestion() {
    suggestOpenVpn = false;
  }

  void onDialogShown() => _analyticsStore.logEvent(AnalyticsEvent.dpiProtocolFallbackDialogShown);

  void onDecision({required bool accepted}) => _analyticsStore.logEvent(
    accepted
        ? AnalyticsEvent.dpiProtocolFallbackAccepted
        : AnalyticsEvent.dpiProtocolFallbackDeclined,
  );

  void onFallbackOutcome({required bool reconnected, Object? error}) => _analyticsStore.logEvent(
    error == null && reconnected
        ? AnalyticsEvent.dpiProtocolFallbackSucceeded
        : AnalyticsEvent.dpiProtocolFallbackFailed,
    parameters: {
      'protocol': ProtocolType.openvpn.name,
      'reconnected': reconnected,
      if (error != null) 'error': error.toString(),
    },
  );
}
