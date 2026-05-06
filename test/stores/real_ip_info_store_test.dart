import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'real_ip_info_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ExternalApiService>(),
  MockSpec<SharedPreferenceService>(),
  MockSpec<WireguardDart>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  late MockExternalApiService api;
  late MockSharedPreferenceService preferences;
  late MockWireguardDart wireguard;
  late MockAnalyticsStore analytics;

  const fetchedInfo = IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1');
  const cachedInfo = IPInfo(country: 'CA', city: 'Toronto', ip: '2.2.2.2');

  setUp(() {
    api = MockExternalApiService();
    preferences = MockSharedPreferenceService();
    wireguard = MockWireguardDart();
    analytics = MockAnalyticsStore();

    when(api.getIPInfo()).thenAnswer((_) async => fetchedInfo);
    when(preferences.getIPInfo()).thenReturn(cachedInfo);
    when(preferences.setIPInfo(any)).thenAnswer((_) async {});
    when(wireguard.status()).thenAnswer((_) async => ConnectionStatus.disconnected);
  });

  RealIPInfoStore newStore() => RealIPInfoStore(api, preferences, wireguard, analytics);

  test('fetches fresh IP info when not connected to VPN', () async {
    final store = newStore();
    await store.infoFuture;

    expect(store.info, fetchedInfo);
    verify(api.getIPInfo()).called(1);
    verify(preferences.setIPInfo(fetchedInfo)).called(1);
  });

  test('returns cached IP info when connected to VPN', () async {
    when(wireguard.status()).thenAnswer((_) async => ConnectionStatus.connected);

    final store = newStore();
    await store.infoFuture;

    expect(store.info, cachedInfo);
    verifyNever(api.getIPInfo());
  });

  test('treats "unknown" status as disconnected (fetches fresh)', () async {
    when(wireguard.status()).thenAnswer((_) async => ConnectionStatus.unknown);

    final store = newStore();
    await store.infoFuture;

    verify(api.getIPInfo()).called(1);
  });

  test('reports countryUser as a user property after fetch', () async {
    final store = newStore();
    await store.infoFuture;
    // setUserProperty is called via unawaited — give it a microtask.
    await Future<void>.delayed(Duration.zero);

    verify(analytics.setUserProperty(any)).called(1);
  });

  test('refresh re-fetches IP info', () async {
    final store = newStore();
    await store.infoFuture;
    clearInteractions(api);

    await store.refresh();

    verify(api.getIPInfo()).called(1);
  });
}
