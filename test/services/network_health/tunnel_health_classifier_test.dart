import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_classifier.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_types.dart';

void main() {
  const fast = (elapsed: Duration(milliseconds: 50), ip: '1.1.1.1', error: null);
  const slowDirect = (elapsed: Duration(milliseconds: 200), ip: '2.2.2.2', error: null);
  const failed = (elapsed: null, ip: null, error: 'boom');

  TunnelHealthVerdict classify({
    required TunnelHealthLeg tunnelled,
    required TunnelHealthLeg direct,
    bool bypassVerified = true,
    bool connected = true,
    bool controlReachable = true,
    bool tunnelCarriedData = false,
  }) => classifyTunnelHealth(
    sample: TunnelHealthSample(
      tunnelled: tunnelled,
      direct: direct,
      bypassVerified: bypassVerified,
      controlReachable: controlReachable,
    ),
    tunnelCarriedData: tunnelCarriedData,
    degradedFloorMs: 1500,
    latencyRatioPercent: 200,
    connected: connected,
  );

  test('both legs failing with the control down is the user being offline', () {
    expect(
      classify(tunnelled: failed, direct: failed, controlReachable: false),
      TunnelHealthVerdict.noNetwork,
    );
  });

  test('both legs failing while the control answers blames the node', () {
    // The tunnel pushes DNS, so its failure takes both HTTP legs with it. The
    // control needs no DNS, so it proves the user's network is fine.
    expect(classify(tunnelled: failed, direct: failed), TunnelHealthVerdict.degraded);
  });

  test('counters showing the tunnel carried data still veto that', () {
    expect(
      classify(tunnelled: failed, direct: failed, tunnelCarriedData: true),
      TunnelHealthVerdict.inconclusive,
    );
  });

  group('disconnected', () {
    test('both legs and the control failing is no network', () {
      expect(
        classify(tunnelled: failed, direct: failed, connected: false, controlReachable: false),
        TunnelHealthVerdict.noNetwork,
      );
    });

    test('a reachable control alone means the device is online', () {
      expect(
        classify(tunnelled: failed, direct: failed, connected: false),
        TunnelHealthVerdict.healthy,
      );
    });

    test('one leg answering means the device is online', () {
      expect(
        classify(tunnelled: failed, direct: slowDirect, connected: false),
        TunnelHealthVerdict.healthy,
      );
    });

    test('a slow pair is never degraded without a tunnel to blame', () {
      expect(
        classify(
          tunnelled: (elapsed: const Duration(milliseconds: 4000), ip: '1.1.1.1', error: null),
          direct: (elapsed: const Duration(milliseconds: 200), ip: '2.2.2.2', error: null),
          connected: false,
        ),
        TunnelHealthVerdict.healthy,
      );
    });

    test('an unverified bypass is irrelevant without a tunnel', () {
      expect(
        classify(tunnelled: fast, direct: slowDirect, bypassVerified: false, connected: false),
        TunnelHealthVerdict.healthy,
      );
    });
  });

  test('a failed direct leg cannot implicate the tunnel', () {
    expect(classify(tunnelled: fast, direct: failed), TunnelHealthVerdict.inconclusive);
  });

  test('an unverified bypass suppresses the verdict', () {
    expect(
      classify(tunnelled: failed, direct: slowDirect, bypassVerified: false),
      TunnelHealthVerdict.bypassUnavailable,
    );
  });

  test('tunnel dead while the control path works is degraded', () {
    expect(classify(tunnelled: failed, direct: slowDirect), TunnelHealthVerdict.degraded);
  });

  test('stats proving the tunnel carried data veto the hard case', () {
    expect(
      classify(tunnelled: failed, direct: slowDirect, tunnelCarriedData: true),
      TunnelHealthVerdict.inconclusive,
    );
  });

  test('both legs healthy is healthy', () {
    expect(classify(tunnelled: fast, direct: slowDirect), TunnelHealthVerdict.healthy);
  });

  test('past the floor but under the ratio stays healthy', () {
    // 1600ms tunnelled vs 1000ms direct: over the floor, under 2x.
    expect(
      classify(
        tunnelled: (elapsed: const Duration(milliseconds: 1600), ip: '1.1.1.1', error: null),
        direct: (elapsed: const Duration(milliseconds: 1000), ip: '2.2.2.2', error: null),
      ),
      TunnelHealthVerdict.healthy,
    );
  });

  test('over the ratio but under the floor stays healthy', () {
    // 400ms vs 50ms is 8x, but nowhere near the 1500ms floor.
    expect(
      classify(
        tunnelled: (elapsed: const Duration(milliseconds: 400), ip: '1.1.1.1', error: null),
        direct: (elapsed: const Duration(milliseconds: 50), ip: '2.2.2.2', error: null),
      ),
      TunnelHealthVerdict.healthy,
    );
  });

  test('over both guards is degraded', () {
    expect(
      classify(
        tunnelled: (elapsed: const Duration(milliseconds: 2000), ip: '1.1.1.1', error: null),
        direct: (elapsed: const Duration(milliseconds: 200), ip: '2.2.2.2', error: null),
      ),
      TunnelHealthVerdict.degraded,
    );
  });

  test('stats do not veto the soft case', () {
    expect(
      classify(
        tunnelled: (elapsed: const Duration(milliseconds: 2000), ip: '1.1.1.1', error: null),
        direct: (elapsed: const Duration(milliseconds: 200), ip: '2.2.2.2', error: null),
        tunnelCarriedData: true,
      ),
      TunnelHealthVerdict.degraded,
    );
  });
}
