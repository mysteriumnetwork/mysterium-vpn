import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';

@GenerateNiceMocks([
  MockSpec<RemoteConfigStore>(),
  MockSpec<VpnProtocolStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
])
import 'udp_blocked_suggestion_store_test.mocks.dart';

void main() {
  late MockRemoteConfigStore remoteConfig;
  late MockVpnProtocolStore protocolStore;
  late MockAuthSessionStore authSession;
  late MockAnalyticsStore analytics;
  late UdpBlockedSuggestionStore store;

  setUp(() {
    remoteConfig = MockRemoteConfigStore();
    protocolStore = MockVpnProtocolStore();
    authSession = MockAuthSessionStore();
    analytics = MockAnalyticsStore();

    when(remoteConfig.shouldCheckUdp).thenReturn(true);
    when(protocolStore.isProtocolPickerAvailable).thenReturn(true);
    when(protocolStore.protocol).thenReturn(ProtocolType.wireguard);
    when(authSession.isAuthenticated).thenReturn(true);

    store = UdpBlockedSuggestionStore(remoteConfig, protocolStore, authSession, analytics);
  });

  group('shouldRunCheck', () {
    test('is true on WireGuard when the remote flag allows it', () {
      expect(store.shouldRunCheck, true);
    });

    test('is false on OpenVPN — already TCP, so the result is not actionable', () {
      when(protocolStore.protocol).thenReturn(ProtocolType.openvpn);

      expect(store.shouldRunCheck, false);
    });

    test('is false when shouldCheckUdp is off', () {
      when(remoteConfig.shouldCheckUdp).thenReturn(false);

      expect(store.shouldRunCheck, false);
    });
  });

  group('isOpenVpnAvailable', () {
    test('is true when the picker flag is on and the session is authenticated', () {
      expect(store.isOpenVpnAvailable, true);
    });

    test('is false when the protocol picker is not available', () {
      when(protocolStore.isProtocolPickerAvailable).thenReturn(false);

      expect(store.isOpenVpnAvailable, false);
    });

    test('is false when unauthenticated', () {
      when(authSession.isAuthenticated).thenReturn(false);

      expect(store.isOpenVpnAvailable, false);
    });
  });

  group('onUdpBlocked', () {
    test('raises the suggestion and logs detection plus the fallback trigger', () {
      store.onUdpBlocked('timeout');

      expect(store.suggestionEpoch, 1);
      verify(
        analytics.logEvent(
          AnalyticsEvent.udpBlocked,
          parameters: {'error': 'timeout', 'suggested': true},
        ),
      ).called(1);
      verify(
        analytics.logEvent(
          AnalyticsEvent.dpiProtocolFallbackTriggered,
          parameters: {'error': 'timeout', 'from_protocol': 'wireguard'},
        ),
      ).called(1);
    });

    test('logs detection but never the trigger when OpenVPN is unavailable', () {
      when(protocolStore.isProtocolPickerAvailable).thenReturn(false);

      store.onUdpBlocked('timeout');

      expect(store.suggestionEpoch, 0);
      verify(
        analytics.logEvent(
          AnalyticsEvent.udpBlocked,
          parameters: {'error': 'timeout', 'suggested': false},
        ),
      ).called(1);
      verifyNever(
        analytics.logEvent(
          AnalyticsEvent.dpiProtocolFallbackTriggered,
          parameters: anyNamed('parameters'),
        ),
      );
    });
  });

  group('funnel events', () {
    test('onDialogShown logs the dialog-shown event', () {
      store.onDialogShown();

      verify(analytics.logEvent(AnalyticsEvent.dpiProtocolFallbackDialogShown)).called(1);
    });

    test('onDecision logs accepted or declined', () {
      store.onDecision(accepted: true);
      verify(analytics.logEvent(AnalyticsEvent.dpiProtocolFallbackAccepted)).called(1);

      store.onDecision(accepted: false);
      verify(analytics.logEvent(AnalyticsEvent.dpiProtocolFallbackDeclined)).called(1);
    });

    test('onFallbackOutcome logs success only when the reconnect landed', () {
      store.onFallbackOutcome(reconnected: true);

      verify(
        analytics.logEvent(
          AnalyticsEvent.dpiProtocolFallbackSucceeded,
          parameters: {'protocol': 'openvpn', 'reconnected': true},
        ),
      ).called(1);
    });

    test('onFallbackOutcome logs a failure carrying the error', () {
      store.onFallbackOutcome(reconnected: false, error: Exception('boom'));

      verify(
        analytics.logEvent(
          AnalyticsEvent.dpiProtocolFallbackFailed,
          parameters: {'protocol': 'openvpn', 'reconnected': false, 'error': 'Exception: boom'},
        ),
      ).called(1);
    });
  });

  test('every detection advances the epoch, so none is ever swallowed', () {
    store.onUdpBlocked('timeout');
    expect(store.suggestionEpoch, 1);

    // The view may not have consumed the first one — e.g. Home was unmounted.
    // A flag would already be `true` here and produce no observable change.
    store.onUdpBlocked('timeout again');

    expect(store.suggestionEpoch, 2);
  });
}
