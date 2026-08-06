import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/smart_refresh_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'smart_refresh_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<SubscriptionService>(),
  MockSpec<SharedPreferenceService>(),
  MockSpec<Talker>(),
])
void main() {
  late MockLocationsStore locations;
  late MockSubscriptionStore subscriptions;
  late MockAuthSessionStore authSession;
  late MockSubscriptionService subscriptionService;
  late MockSharedPreferenceService prefs;
  late MockTalker logger;

  SmartRefreshStore newStore() =>
      SmartRefreshStore(locations, subscriptions, authSession, subscriptionService, prefs, logger);

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locations = MockLocationsStore();
    subscriptions = MockSubscriptionStore();
    authSession = MockAuthSessionStore();
    subscriptionService = MockSubscriptionService();
    prefs = MockSharedPreferenceService();
    logger = MockTalker();

    when(
      subscriptions.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
    when(
      subscriptions.refreshSubscription(force: true),
    ).thenAnswer((_) async => Subscription.empty());
    when(authSession.isAuthenticated).thenReturn(false);
    when(locations.refreshAll()).thenAnswer((_) async {});
    when(prefs.getBool(any)).thenReturn(false);
    when(prefs.setBool(any, value: anyNamed('value'))).thenAnswer((_) async => true);
    when(subscriptionService.resyncStorePurchase()).thenAnswer((_) async {});
  });

  test('constructs and disposes cleanly', () async {
    final store = newStore();
    await store.dispose();
  });

  test('refreshOnResume with shouldVerifyPurchase re-posts token then refreshes', () async {
    when(prefs.getBool(StorageKeys.shouldVerifyPurchase.name)).thenReturn(true);

    final store = newStore();
    addTearDown(store.dispose);

    await store.refreshStoreSubscription();

    verify(subscriptionService.resyncStorePurchase()).called(1);
    verify(prefs.setBool(StorageKeys.shouldVerifyPurchase.name, value: false)).called(1);
    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });

  test('refreshOnResume without flag only refreshes subscription', () async {
    final store = newStore();
    addTearDown(store.dispose);

    await store.refreshStoreSubscription();

    verifyNever(subscriptionService.resyncStorePurchase());
    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });

  test('refreshOnResume keeps flag when token re-post fails', () async {
    when(prefs.getBool(StorageKeys.shouldVerifyPurchase.name)).thenReturn(true);
    when(subscriptionService.resyncStorePurchase()).thenThrow(Exception('offline'));

    final store = newStore();
    addTearDown(store.dispose);

    await store.refreshStoreSubscription();

    verifyNever(prefs.setBool(StorageKeys.shouldVerifyPurchase.name, value: false));
    verify(subscriptions.refreshSubscription(force: true)).called(1);
  });
}
