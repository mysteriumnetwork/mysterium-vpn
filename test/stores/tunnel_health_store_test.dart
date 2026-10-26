import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'tunnel_health_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TunnelHealthProbe>(),
  MockSpec<TunnelHealthReporter>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<VpnStore>(),
  MockSpec<VpnProtocolStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const location = VPNLocation(
    id: 'de',
    ipType: IPType.datacenter,
    translations: {},
    countryCode: 'de',
  );

  const healthy = TunnelHealthSample(
    tunnelled: (elapsed: Duration(milliseconds: 50), ip: '10.0.0.1', error: null),
    direct: (elapsed: Duration(milliseconds: 200), ip: '203.0.113.9', error: null),
    bypassVerified: true,
    controlReachable: true,
  );

  const degraded = TunnelHealthSample(
    tunnelled: (elapsed: null, ip: null, error: 'timeout'),
    direct: (elapsed: Duration(milliseconds: 200), ip: '203.0.113.9', error: null),
    bypassVerified: true,
    controlReachable: true,
  );

  late MockTunnelHealthProbe probe;
  late MockTunnelHealthReporter reporter;
  late MockRemoteConfigStore config;
  late MockAnalyticsStore analytics;
  late MockVpnStore vpnStore;
  late MockVpnProtocolStore protocolStore;
  late DateTime now;

  /// Flipped by the signed-out test; every other test runs authenticated.
  late bool authenticated;

  // Matcher registration happens during argument evaluation, so wrapping the
  // call keeps `verify`/`when` working while naming it once.
  Future<TunnelHealthSample> anyProbe() =>
      probe.probe(exitIp: anyNamed('exitIp'), controlIps: anyNamed('controlIps'));

  void stubProbe(TunnelHealthSample sample) => when(anyProbe()).thenAnswer((_) async => sample);

  Future<void> anyReport() => reporter.report(
    sessionId: anyNamed('sessionId'),
    hash: anyNamed('hash'),
    destinationCountry: anyNamed('destinationCountry'),
    trigger: anyNamed('trigger'),
  );

  setUp(() {
    authenticated = true;
    probe = MockTunnelHealthProbe();
    reporter = MockTunnelHealthReporter();
    config = MockRemoteConfigStore();
    analytics = MockAnalyticsStore();
    vpnStore = MockVpnStore();
    protocolStore = MockVpnProtocolStore();
    when(protocolStore.protocol).thenReturn(ProtocolType.wireguard);
    now = DateTime.utc(2026, 10, 6, 12);

    when(
      config.tunnelHealthConfig,
    ).thenReturn(const TunnelHealthConfig(enabled: true, minBackgroundSeconds: 60));

    when(vpnStore.isConnected).thenReturn(true);
    when(vpnStore.connectedIpPoolCount).thenReturn(5);
    when(vpnStore.vpnConnection).thenReturn(
      const VpnConnection(
        connectionIP: '10.0.0.1',
        location: location,
        sessionId: 'sess-1',
        hash: 'hash-abc',
      ),
    );
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async => null);
    stubProbe(healthy);
    when(anyReport()).thenAnswer((_) async {});
  });

  TunnelHealthStore build({void Function(VoidCallback)? schedule}) {
    final store = TunnelHealthStore(
      probe,
      reporter,
      vpnStore,
      protocolStore,
      config,
      analytics,
      Talker(),
      () => authenticated,
      clock: () => now,
      confirmDelay: Duration.zero,
      // Run inline: a plain test() never pumps a frame.
      schedule: schedule ?? (callback) => callback(),
    );
    addTearDown(store.dispose);
    return store;
  }

  /// Replays the states Flutter actually emits. `paused` is never delivered
  /// immediately before `resumed`: ServicesBinding expands the gap into
  /// hidden -> inactive -> resumed, one observer callback each.
  Future<void> resumeAfter(TunnelHealthStore store, Duration backgrounded) async {
    store.didChangeAppLifecycleState(AppLifecycleState.paused);
    now = now.add(backgrounded);
    store
      ..didChangeAppLifecycleState(AppLifecycleState.hidden)
      ..didChangeAppLifecycleState(AppLifecycleState.inactive)
      ..didChangeAppLifecycleState(AppLifecycleState.resumed);
    await store.pendingCheck;
  }

  group('trigger', () {
    test('probes on resume after the minimum background duration', () async {
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      verify(anyProbe()).called(1);
    });

    test('does not probe when backgrounded for less than the minimum', () async {
      final store = build();
      await resumeAfter(store, const Duration(seconds: 10));

      verifyNever(anyProbe());
    });

    test('does not probe when the kill switch is off', () async {
      when(config.tunnelHealthConfig).thenReturn(const TunnelHealthConfig());
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      verifyNever(anyProbe());
    });

    test('does not probe while signed out', () async {
      // The store is constructed at startup, so the observer is live on the
      // login screen. Probing there is pointless, and flushing would drain the
      // queue only to have every report rejected as unauthenticated.
      authenticated = false;
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      verifyNever(anyProbe());
    });

    test('a callback queued before backgrounding is dropped, not run late', () async {
      // Backgrounding cannot cancel a queued post-frame callback and no frame
      // paints while away, so it survives to the next resume. Without a
      // generation token it would run then, alongside the fresh one.
      // Driven directly rather than via resumeAfter, which awaits
      // pendingCheck - and nothing completes it while the callback is held.
      final pending = <VoidCallback>[];
      final store = build(schedule: pending.add);

      void lifecycle(AppLifecycleState state) => store.didChangeAppLifecycleState(state);

      lifecycle(AppLifecycleState.paused);
      now = now.add(const Duration(minutes: 10));
      lifecycle(AppLifecycleState.hidden);
      lifecycle(AppLifecycleState.inactive);
      lifecycle(AppLifecycleState.resumed);
      expect(pending, hasLength(1));

      lifecycle(AppLifecycleState.paused);

      pending.single();
      await pumpEventQueue();

      verifyNever(anyProbe());
    });

    test('does not probe when the minimum is 0 (disabled)', () async {
      when(
        config.tunnelHealthConfig,
      ).thenReturn(const TunnelHealthConfig(enabled: true, minBackgroundSeconds: 0));
      final store = build();
      await resumeAfter(store, const Duration(hours: 2));

      verifyNever(anyProbe());
    });

    test('probes even when disconnected — the no-network check still applies', () async {
      when(vpnStore.isConnected).thenReturn(false);
      when(vpnStore.vpnConnection).thenReturn(null);
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      verify(anyProbe()).called(greaterThanOrEqualTo(1));
    });

    test('does not probe on a resume that was not preceded by a pause', () async {
      final store = build()..didChangeAppLifecycleState(AppLifecycleState.resumed);
      await store.pendingCheck;

      verifyNever(anyProbe());
    });
  });

  group('backgrounded detection', () {
    test('desktop never delivers paused, so inactive starts the clock', () async {
      // What macOS/Windows actually emit when the window loses focus.
      final store = build()..didChangeAppLifecycleState(AppLifecycleState.inactive);
      now = now.add(const Duration(minutes: 10));
      store.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await store.pendingCheck;

      verify(anyProbe()).called(1);
    });

    test('the first non-resumed state wins, so the clock is not restarted', () async {
      // Mobile's real chain: the hidden -> paused hop must not reset it.
      final store = build()..didChangeAppLifecycleState(AppLifecycleState.inactive);
      now = now.add(const Duration(minutes: 10));
      store
        ..didChangeAppLifecycleState(AppLifecycleState.hidden)
        ..didChangeAppLifecycleState(AppLifecycleState.paused)
        ..didChangeAppLifecycleState(AppLifecycleState.resumed);
      await store.pendingCheck;

      verify(anyProbe()).called(1);
    });

    test('a brief interruption is still too short to qualify', () async {
      final store = build()..didChangeAppLifecycleState(AppLifecycleState.inactive);
      now = now.add(const Duration(seconds: 2));
      store.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await store.pendingCheck;

      verifyNever(anyProbe());
    });
  });

  group('verdict', () {
    test('a healthy sample raises nothing', () async {
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 0);
      verifyNever(anyReport());
    });

    test('a confirmed degraded sample bumps the epoch and reports', () async {
      stubProbe(degraded);
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 1);
      verify(anyReport()).called(1);
    });

    test('a degraded verdict that does not reconfirm stays silent', () async {
      var call = 0;
      when(anyProbe()).thenAnswer((_) async => call++ == 0 ? degraded : healthy);
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 0);
      verifyNever(anyReport());
    });

    test('disconnecting during the confirm delay aborts', () async {
      when(anyProbe()).thenAnswer((_) async {
        when(vpnStore.isConnected).thenReturn(false);
        return degraded;
      });
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 0);
      verify(anyProbe()).called(1);
    });

    test('a confirmed no-network verdict bumps the snackbar epoch', () async {
      const offline = TunnelHealthSample(
        tunnelled: (elapsed: null, ip: null, error: 'timeout'),
        direct: (elapsed: null, ip: null, error: 'timeout'),
        bypassVerified: false,
        controlReachable: false,
      );
      stubProbe(offline);
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.noNetworkEpoch, 1);
      expect(store.degradationEpoch, 0);
      verifyNever(anyReport());
    });

    test('no-network fires again on every confirmed verdict — it is ungated', () async {
      const offline = TunnelHealthSample(
        tunnelled: (elapsed: null, ip: null, error: 'timeout'),
        direct: (elapsed: null, ip: null, error: 'timeout'),
        bypassVerified: false,
        controlReachable: false,
      );
      stubProbe(offline);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.noNetworkEpoch, 2);
    });

    test('an unverified bypass stays silent whatever the timings say', () async {
      when(anyProbe()).thenAnswer(
        (_) async => const TunnelHealthSample(
          tunnelled: (elapsed: null, ip: null, error: 'timeout'),
          direct: (elapsed: Duration(milliseconds: 200), ip: '10.0.0.1', error: null),
          bypassVerified: false,
          controlReachable: true,
        ),
      );
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 0);
    });
  });

  group('refresh availability', () {
    test('an unknown pool size still offers a refresh', () {
      when(vpnStore.connectedIpPoolCount).thenReturn(0);

      expect(build().canRefreshIp, isTrue);
    });

    test('a pool of exactly one does not', () {
      when(vpnStore.connectedIpPoolCount).thenReturn(1);

      expect(build().canRefreshIp, isFalse);
    });

    test('a larger pool does', () {
      when(vpnStore.connectedIpPoolCount).thenReturn(5);

      expect(build().canRefreshIp, isTrue);
    });
  });

  group('stats corroboration', () {
    test('a tunnel that moved data both ways vetoes the hard case', () async {
      stubProbe(degraded);
      var reads = 0;
      when(vpnStore.tunnelStatistics()).thenAnswer((_) async {
        reads++;
        return TunnelStats(totalDownload: reads * 100000, totalUpload: reads * 100000);
      });
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 0);
    });

    test('a stats read that throws leaves the verdict untouched', () async {
      stubProbe(degraded);
      when(vpnStore.tunnelStatistics()).thenThrow(Exception('no plugin'));
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 1);
    });
  });

  group('gating', () {
    test('reports the session fields the backend keys on, triggered as auto', () async {
      stubProbe(degraded);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));

      final call = verify(
        reporter.report(
          sessionId: captureAnyNamed('sessionId'),
          hash: captureAnyNamed('hash'),
          destinationCountry: captureAnyNamed('destinationCountry'),
          trigger: captureAnyNamed('trigger'),
        ),
      )..called(1);

      expect(call.captured, ['sess-1', 'hash-abc', 'de', TunnelHealthTrigger.auto]);
    });

    test('reports a session only once across several degraded resumes', () async {
      stubProbe(degraded);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));
      await resumeAfter(store, const Duration(minutes: 10));

      verify(anyReport()).called(1);
    });

    test('reports again once the session id changes', () async {
      stubProbe(degraded);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));
      when(vpnStore.vpnConnection).thenReturn(
        const VpnConnection(connectionIP: '10.0.0.2', location: location, sessionId: 'sess-2'),
      );
      await resumeAfter(store, const Duration(minutes: 10));

      verify(anyReport()).called(2);
    });

    test('skips the report when there is no session id but still prompts', () async {
      stubProbe(degraded);
      when(
        vpnStore.vpnConnection,
      ).thenReturn(const VpnConnection(connectionIP: '10.0.0.1', location: location));
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      verifyNever(anyReport());
      expect(store.degradationEpoch, 1);
    });

    test('does not bump the epoch twice for one session once shown', () async {
      stubProbe(degraded);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));
      store.onDialogShown();
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 1);
    });

    test('bumps again if the dialog never opened', () async {
      stubProbe(degraded);
      final store = build();

      await resumeAfter(store, const Duration(minutes: 10));
      await resumeAfter(store, const Duration(minutes: 10));

      expect(store.degradationEpoch, 2);
    });
  });

  group('lifecycle', () {
    test('dispose removes the observer and clears the session sets', () async {
      stubProbe(degraded);
      final store = build();
      await resumeAfter(store, const Duration(minutes: 10));

      store.dispose();
      // Counted from here: a confirmed verdict already probed twice above.
      clearInteractions(probe);
      await resumeAfter(store, const Duration(minutes: 10));

      verifyNever(anyProbe());
    });
  });
}
