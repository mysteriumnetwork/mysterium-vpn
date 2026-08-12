import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/smart_refresh_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'smart_refresh_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<Talker>(),
])
void main() {
  late MockLocationsStore locations;
  late MockSubscriptionStore subscriptions;
  late MockAuthSessionStore authSession;
  late MockTalker logger;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locations = MockLocationsStore();
    subscriptions = MockSubscriptionStore();
    authSession = MockAuthSessionStore();
    logger = MockTalker();

    when(
      subscriptions.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
    when(authSession.isAuthenticated).thenReturn(false);
    when(locations.refreshAll()).thenAnswer((_) async {});
    when(
      subscriptions.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => Subscription.empty());
  });

  SmartRefreshStore buildStore() {
    final store = SmartRefreshStore(locations, subscriptions, authSession, logger);
    addTearDown(store.dispose);
    return store;
  }

  test('constructs and disposes cleanly', () async {
    final store = SmartRefreshStore(locations, subscriptions, authSession, logger);
    await store.dispose();
  });

  test('resume refresh calls refreshSubscription(force: true)', () async {
    final store = buildStore();

    await store.refreshSubscriptionOnResume();

    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });

  test('resume refresh logs errors without rethrowing', () async {
    final error = Exception('offline');
    when(
      subscriptions.refreshSubscription(force: anyNamed('force')),
    ).thenAnswer((_) async => throw error);

    final store = buildStore();

    await store.refreshSubscriptionOnResume();

    verify(logger.handle(error, any)).called(1);
  });
}
