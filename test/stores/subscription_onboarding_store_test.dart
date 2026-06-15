import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'subscription_onboarding_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockLocalDBService localDBService;
  late SubscriptionOnboardingStore store;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    localDBService = MockLocalDBService();

    when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => false);
    when(localDBService.setSubscriptionOnboardingShown()).thenAnswer((_) async {});
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    store = SubscriptionOnboardingStore(
      analyticsStore: analyticsStore,
      subscriptionStore: subscriptionStore,
      localDBService: localDBService,
    );
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

  group('startTour', () {
    test('defaults to false', () {
      // assert
      expect(store.startTour, isFalse);
    });

    test('showSubscriptionOnboarding sets startTour to true', () {
      // act
      store.showSubscriptionOnboarding();

      // assert
      expect(store.startTour, isTrue);
    });

    test('markShown resets startTour to false', () async {
      // arrange
      store.showSubscriptionOnboarding();

      // act
      await store.markShown();

      // assert
      expect(store.startTour, isFalse);
    });

    test('showSubscriptionOnboarding can retrigger after markShown', () async {
      // arrange
      store.showSubscriptionOnboarding();
      await store.markShown();

      // act
      store.showSubscriptionOnboarding();

      // assert
      expect(store.startTour, isTrue);
    });
  });

  test('markShown persists subscription onboarding shown flag', () async {
    // arrange
    await store.markShown();

    // assert
    verify(localDBService.setSubscriptionOnboardingShown()).called(1);
  });

  test('clearShown resets subscription onboarding shown flag', () async {
    // arrange
    await store.clearShown();

    // assert
    verify(localDBService.resetSubscriptionOnboardingShown()).called(1);
  });

  test('trackSkipped logs skipped analytics event', () {
    // act
    store.trackSkipped();

    // assert
    verify(analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedSkipped)).called(1);
  });

  test('trackStarted logs started analytics event', () {
    // act
    store.trackStarted();

    // assert
    verify(analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedStarted)).called(1);
  });

  test('trackFinished logs finished analytics event', () {
    // act
    store.trackFinished();

    // assert
    verify(analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedFinished)).called(1);
  });

  test('trackStepViewed logs one-based step parameter', () {
    // act
    store.trackStepViewed(2);

    // assert
    verify(
      analyticsStore.logEvent(
        AnalyticsEvent.onboardingSubscribedStepViewed,
        parameters: {'step': 3},
      ),
    ).called(1);
  });

  test('trackStepCompleted logs one-based step parameter', () {
    // act
    store.trackStepCompleted(3);

    // assert
    verify(
      analyticsStore.logEvent(
        AnalyticsEvent.onboardingSubscribedStepCompleted,
        parameters: {'step': 4},
      ),
    ).called(1);
  });
}
