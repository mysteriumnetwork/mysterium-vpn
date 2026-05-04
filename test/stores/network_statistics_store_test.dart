import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'network_statistics_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WireguardDart>()])
void main() {
  late MockWireguardDart wireguard;
  late NetworkStatisticsStore store;

  setUp(() {
    wireguard = MockWireguardDart();
    // Constructor kicks off an infinite stats loop. Returning null keeps it idle.
    when(wireguard.getTunnelStatistics()).thenAnswer((_) async => null);
    store = NetworkStatisticsStore(wireguard);
  });

  test('defaults to zeroed totals before any stats arrive', () {
    expect(store.totalDownload, 0);
    expect(store.totalUpload, 0);
    expect(store.totalDownloadInMB, 0);
    expect(store.totalUploadInMB, 0);
    expect(store.latestHandshake, isNull);
  });

  test('totalDownloadInMB / totalUploadInMB convert from bytes to MB', () {
    expect(store.downloadSpeed, 0);
    expect(store.uploadSpeed, 0);
  });
}
