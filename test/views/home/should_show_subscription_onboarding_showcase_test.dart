import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/subscription_onboarding_showcase.dart';

import 'should_show_subscription_onboarding_showcase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;
  late MockLocalDBService localDBService;
  late MockRemoteConfigStore remoteConfigStore;
  late SubscriptionOnboardingStore subscriptionOnboardingStore;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    localDBService = MockLocalDBService();
    remoteConfigStore = MockRemoteConfigStore();

    when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => false);
    when(localDBService.setSubscriptionOnboardingShown()).thenAnswer((_) async {});
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    subscriptionOnboardingStore = SubscriptionOnboardingStore(
      analyticsStore: analyticsStore,
      subscriptionStore: subscriptionStore,
      localDBService: localDBService,
    );
  });

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [
      remoteConfigStorePOD.overrideWithValue(remoteConfigStore),
      subscriptionOnboardingStorePOD.overrideWithValue(subscriptionOnboardingStore),
    ],
  );

  group('shouldShowSubscriptionOnboardingShowcasePOD', () {
    test('returns false when remote config disables the flow', () async {
      // arrange
      when(remoteConfigStore.canShowSubscriptionOnboardingFlow).thenReturn(false);

      final container = createContainer();
      addTearDown(container.dispose);

      // act
      final result = await container.read(shouldShowSubscriptionOnboardingShowcasePOD.future);

      // assert
      expect(result, isFalse);
      verifyNever(localDBService.getSubscriptionOnboardingShown());
    });

    test('returns false when onboarding was already shown', () async {
      // arrange
      when(remoteConfigStore.canShowSubscriptionOnboardingFlow).thenReturn(true);
      when(localDBService.getSubscriptionOnboardingShown()).thenAnswer((_) async => true);

      final container = createContainer();
      addTearDown(container.dispose);

      // act
      final result = await container.read(shouldShowSubscriptionOnboardingShowcasePOD.future);

      // assert
      expect(result, isFalse);
    });

    test('returns true for active subscription when eligible', () async {
      // arrange
      when(remoteConfigStore.canShowSubscriptionOnboardingFlow).thenReturn(true);
      when(subscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(Subscription(active: true, expired: false, recurring: true)),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      // act
      final result = await container.read(shouldShowSubscriptionOnboardingShowcasePOD.future);

      // assert
      expect(result, isTrue);
    });
  });
}
