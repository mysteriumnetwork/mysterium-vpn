import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'subscription_onboarding_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<HomeTabsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late MockAnalyticsStore analyticsStore;
  late MockHomeTabsStore homeTabsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockLocalDBService localDBService;
  late SubscriptionOnboardingStore store;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    homeTabsStore = MockHomeTabsStore();
    subscriptionStore = MockSubscriptionStore();
    localDBService = MockLocalDBService();

    when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => false);
    when(localDBService.setSubscriptionOnboardingShown()).thenAnswer((_) async {});
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    store = SubscriptionOnboardingStore(
      analyticsStore: analyticsStore,
      homeTabsStore: homeTabsStore,
      subscriptionStore: subscriptionStore,
      localDBService: localDBService,
    );
  });

  tearDown(() {
    store.dispose();
  });

  test('shouldShow returns false when onboarding was already shown', () async {
    //arrange
    when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => true);

    // act
    final result = await store.shouldShow();

    // assert
    expect(result, isFalse);
    verifyNever(subscriptionStore.subscriptionFuture);
  });

  test('shouldShow returns true for active subscription when onboarding was not shown', () async {
    // arrange
    when(subscriptionStore.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(Subscription(active: true, expired: false, recurring: true)),
    );

    // act
    final result = await store.shouldShow();

    // assert
    expect(result, isTrue);
  });

  test('shouldShow returns false for inactive subscription', () async {
    // arrange
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    // act
    final result = await store.shouldShow();

    // assert
    expect(result, isFalse);
  });

  test('shouldShow returns false when subscription lookup fails', () async {
    // arrange
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture(Future<Subscription>.error(Exception('network'))));

    // act
    final result = await store.shouldShow();

    // assert
    expect(result, isFalse);
  });

  test('markShown persists subscription onboarding shown flag', () async {
    // arrange
    await store.markShown();

    // assert
    verify(localDBService.setSubscriptionOnboardingShown()).called(1);
  });
}
