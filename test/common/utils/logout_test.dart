import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/logout.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'logout_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VpnStore>(), MockSpec<AuthStore>(), MockSpec<AnalyticsStore>()])
void main() {
  late MockVpnStore vpnStore;
  late MockAuthStore authStore;
  late MockAnalyticsStore analytics;

  Future<void> run({Duration timeout = logoutDisconnectTimeout}) => disconnectAndLogout(
    vpnStore: vpnStore,
    authStore: authStore,
    analyticsStore: analytics,
    timeout: timeout,
  );

  setUp(() {
    vpnStore = MockVpnStore();
    authStore = MockAuthStore();
    analytics = MockAnalyticsStore();
    when(authStore.logout()).thenAnswer((_) async {});
  });

  test('tears the tunnel down as app-initiated, then logs out', () async {
    when(vpnStore.disconnectTunnel(reason: anyNamed('reason'))).thenAnswer((_) async {});

    await run();

    verify(vpnStore.disconnectTunnel(reason: VpnDisconnectReason.appInitiated)).called(1);
    verify(authStore.logout()).called(1);
    verifyNever(analytics.logEvent(AnalyticsEvent.logOutDisconnectFailed));
  });

  test('logs out anyway when the teardown hangs, and reports the timeout', () async {
    // Never completes: the real hazard is a wedged platform channel.
    when(
      vpnStore.disconnectTunnel(reason: anyNamed('reason')),
    ).thenAnswer((_) => Completer<void>().future);

    await run(timeout: const Duration(milliseconds: 10));

    verify(authStore.logout()).called(1);
    verify(
      analytics.logEvent(AnalyticsEvent.logOutDisconnectFailed, parameters: {'reason': 'timeout'}),
    ).called(1);
  });

  test('logs out anyway when the teardown throws, and reports the error', () async {
    when(
      vpnStore.disconnectTunnel(reason: anyNamed('reason')),
    ).thenThrow(Exception('platform channel failed'));

    await run();

    verify(authStore.logout()).called(1);
    verify(
      analytics.logEvent(AnalyticsEvent.logOutDisconnectFailed, parameters: {'reason': 'error'}),
    ).called(1);
  });
}
