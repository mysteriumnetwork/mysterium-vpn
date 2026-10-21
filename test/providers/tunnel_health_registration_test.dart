import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'tunnel_health_registration_test.mocks.dart';

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

  const degraded = TunnelHealthSample(
    tunnelled: (elapsed: null, ip: null, error: 'timeout'),
    direct: (elapsed: Duration(milliseconds: 200), ip: '203.0.113.9', error: null),
    bypassVerified: true,
    controlReachable: true,
  );

  late MockTunnelHealthProbe probe;
  late MockVpnStore vpnStore;
  late MockRemoteConfigStore config;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        tunnelHealthProbePOD.overrideWithValue(probe),
        tunnelHealthReporterPOD.overrideWithValue(MockTunnelHealthReporter()),
        vpnStorePOD.overrideWithValue(vpnStore),
        vpnProtocolStorePOD.overrideWithValue(MockVpnProtocolStore()),
        remoteConfigStorePOD.overrideWithValue(config),
        analyticsStorePOD.overrideWithValue(MockAnalyticsStore()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    probe = MockTunnelHealthProbe();
    vpnStore = MockVpnStore();
    config = MockRemoteConfigStore();

    // A nice mock would return false here, which would make the second test
    // pass for a reason unrelated to disposal.
    when(config.tunnelHealthConfig).thenReturn(const TunnelHealthConfig(enabled: true));

    when(vpnStore.isConnected).thenReturn(true);
    when(vpnStore.vpnConnection).thenReturn(
      const VpnConnection(connectionIP: '10.0.0.1', location: location, sessionId: 'sess-1'),
    );
    when(vpnStore.tunnelStatistics()).thenAnswer((_) async => null);
    when(
      probe.probe(exitIp: anyNamed('exitIp'), controlIp: anyNamed('controlIp')),
    ).thenAnswer((_) async => degraded);
  });

  test('the provider builds a live store', () {
    final store = makeContainer().read(tunnelHealthStorePOD);

    expect(store, isA<TunnelHealthStore>());
  });

  test('disposing the container disposes the store — the ref.onDispose guard', () {
    final container = makeContainer();
    final store = container.read(tunnelHealthStorePOD);

    expect(store.isDisposed, isFalse);

    container.dispose();

    // Fails outright if the provider omits ref.onDispose(store.dispose), which
    // would leave the observer registered on WidgetsBinding forever.
    expect(store.isDisposed, isTrue);
  });

  test('a disposed store ignores lifecycle events', () async {
    final container = makeContainer();
    final store = container.read(tunnelHealthStorePOD);

    container.dispose();

    store
      ..didChangeAppLifecycleState(AppLifecycleState.paused)
      ..didChangeAppLifecycleState(AppLifecycleState.resumed);
    await store.pendingCheck;

    verifyNever(probe.probe(exitIp: anyNamed('exitIp'), controlIp: anyNamed('controlIp')));
  });
}
