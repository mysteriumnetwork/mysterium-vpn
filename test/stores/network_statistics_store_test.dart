import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'network_statistics_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VpnStore>()])
void main() {
  const tick = Duration(milliseconds: 5);

  late MockVpnStore vpnStore;
  late NetworkStatisticsStore store;

  setUp(() {
    vpnStore = MockVpnStore();
    // The constructor kicks off an endless poll loop; null keeps it idle.
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async => null);
  });

  tearDown(() => store.disposeStore());

  test('defaults to zeroed counters before any stats arrive', () {
    store = NetworkStatisticsStore(vpnStore, pollInterval: tick);

    expect(store.totalDownload, 0);
    expect(store.totalUpload, 0);
    expect(store.totalDownloadInMB, 0);
    expect(store.totalUploadInMB, 0);
    expect(store.downloadSpeed, 0);
    expect(store.uploadSpeed, 0);
    expect(store.latestHandshake, isNull);
  });

  test('derives speeds from the delta between consecutive samples', () async {
    var sample = 0;
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async {
      sample++;
      // 1 MB down and 0.5 MB up per interval.
      return TunnelStats(totalDownload: sample * 1000000, totalUpload: sample * 500000);
    });

    store = NetworkStatisticsStore(vpnStore, pollInterval: tick);
    await Future<void>.delayed(tick * 6);

    expect(store.totalDownloadInMB, greaterThan(0));
    expect(store.totalUploadInMB, greaterThan(0));
    // 1 MB per 5 ms interval => 8 Mbit / 0.005 s = 1600 Mbps.
    expect(store.downloadSpeed, closeTo(1600, 0.001));
    expect(store.uploadSpeed, closeTo(800, 0.001));
  });

  test('keeps polling after a transient failure', () async {
    var calls = 0;
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw Exception('tunnel went away mid-poll');
      }
      return const TunnelStats(totalDownload: 4000000, totalUpload: 0);
    });

    store = NetworkStatisticsStore(vpnStore, pollInterval: tick);
    await Future<void>.delayed(tick * 6);

    expect(calls, greaterThan(1));
    expect(store.totalDownloadInMB, 4);
  });

  test('stops polling when the platform has no implementation', () async {
    var calls = 0;
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async {
      calls++;
      throw MissingPluginException();
    });

    store = NetworkStatisticsStore(vpnStore, pollInterval: tick);
    await Future<void>.delayed(tick * 8);

    expect(calls, 1);
  });

  test('stops polling once disposed', () async {
    store = NetworkStatisticsStore(vpnStore, pollInterval: tick);
    await Future<void>.delayed(tick * 3);
    store.disposeStore();
    final callsAtDispose = verify(vpnStore.tunnelStatistics()).callCount;

    await Future<void>.delayed(tick * 6);

    verifyNever(vpnStore.tunnelStatistics());
    expect(callsAtDispose, greaterThan(0));
  });
}
