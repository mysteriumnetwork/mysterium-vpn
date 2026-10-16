import 'package:configcat_client/configcat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'ab_testing_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ConfigCatClient>(),
  MockSpec<Talker>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RefreshResult>(),
])
void main() {
  late MockConfigCatClient client;
  late MockTalker logger;
  late MockAnalyticsStore analytics;
  late MockRefreshResult refreshResult;

  setUp(() {
    client = MockConfigCatClient();
    logger = MockTalker();
    analytics = MockAnalyticsStore();
    refreshResult = MockRefreshResult();

    when(refreshResult.isSuccess).thenReturn(true);
    when(client.forceRefresh()).thenAnswer((_) async => refreshResult);
  });

  test('asUserProperties prefixes keys and snake-cases them', () async {
    when(
      client.getAllValues(),
    ).thenAnswer((_) async => {'subscriptionFlow': 'A', 'tunnelConsent': 'B'});

    final store = ABTestingStore(client, logger, analytics);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    expect(store.asUserProperties, {'group_subscription_flow': 'A', 'group_tunnel_consent': 'B'});
  });

  test('reaction emits user properties to analytics after config load', () async {
    when(client.getAllValues()).thenAnswer((_) async => {'subscriptionFlow': 'A'});

    final store = ABTestingStore(client, logger, analytics);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;
    await Future<void>.delayed(Duration.zero);

    verify(analytics.setUserProperty(any)).called(greaterThanOrEqualTo(1));
  });

  group('reviewDestination', () {
    Future<ABTestingStore> storeWith(Map<String, dynamic> values) async {
      when(client.getAllValues()).thenAnswer((_) async => values);
      final store = ABTestingStore(client, logger, analytics);
      await store.setUser(ConfigCatUser(identifier: 'u1'));
      await store.configFuture;
      return store;
    }

    test('defaults to the store prompt when the variant is absent', () async {
      expect((await storeWith({})).reviewDestination, ReviewDestination.store);
    });

    test('returns trustpilot when assigned', () async {
      final store = await storeWith({'reviewDestination': 'trustpilot'});
      expect(store.reviewDestination, ReviewDestination.trustpilot);
    });

    test('returns the store prompt when assigned', () async {
      final store = await storeWith({'reviewDestination': 'store'});
      expect(store.reviewDestination, ReviewDestination.store);
    });

    test('falls back to the store prompt on a wrong-typed value', () async {
      final store = await storeWith({'reviewDestination': 42});
      expect(store.reviewDestination, ReviewDestination.store);
    });

    test('matches a capitalised variant rather than silently using the control arm', () async {
      final store = await storeWith({'reviewDestination': 'Trustpilot'});
      expect(store.reviewDestination, ReviewDestination.trustpilot);
    });

    test('falls back to the store prompt on an unknown variant', () async {
      final store = await storeWith({'reviewDestination': 'yelp'});
      expect(store.reviewDestination, ReviewDestination.store);
    });
  });
}
