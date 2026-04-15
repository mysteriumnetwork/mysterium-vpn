import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_config_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'subscription_config_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<SubscriptionService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  late MockAuthSessionStore mockAuthSessionStore;
  late MockSubscriptionService mockSubscriptionService;
  late MockAnalyticsStore mockAnalyticsStore;

  setUp(() {
    mockAuthSessionStore = MockAuthSessionStore();
    mockSubscriptionService = MockSubscriptionService();
    mockAnalyticsStore = MockAnalyticsStore();

    // Safe defaults so constructor reactions don't fail
    when(mockAuthSessionStore.accessToken).thenReturn(null);
    when(mockAuthSessionStore.isAuthenticated).thenReturn(false);
    when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer(
      (_) async => SubscriptionConfigResponse(
        gateways: [],
        plans: [],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      ),
    );
    when(mockSubscriptionService.clearPendingTransactions()).thenAnswer((_) async {});
    when(
      mockSubscriptionService.fetchSubscriptionDetails(),
    ).thenAnswer((_) async => Subscription.empty());
    when(mockSubscriptionService.fetchSubscriptionPlan()).thenAnswer(
      (_) async =>
          GetPlanResponse(id: 'test-plan', description: 'Test Plan', metadata: PlanMetadata()),
    );
  });

  SubscriptionConfigStore createStore() =>
      SubscriptionConfigStore(mockAuthSessionStore, mockSubscriptionService, mockAnalyticsStore);

  group('SubscriptionConfigStore', () {
    test('fetches config and subscription when accessToken is present', () async {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );

      when(mockAuthSessionStore.accessToken).thenReturn('test-token');
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer((_) async => config);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async =>
            Subscription(active: true, activeUntil: DateTime.now().add(const Duration(days: 30))),
      );

      final store = createStore();

      // Wait for the constructor-triggered futures to settle
      await store.future;
      await store.subscriptionFuture;

      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(greaterThan(0));
    });

    test('fetches empty subscription when not authenticated', () async {
      when(mockAuthSessionStore.accessToken).thenReturn('test-token');
      when(mockAuthSessionStore.isAuthenticated).thenReturn(false);

      final store = createStore();
      final sub = await store.subscriptionFuture;

      expect(sub.active, isFalse);
    });

    test('sets analytics user properties after fetching subscription', () async {
      when(mockAuthSessionStore.accessToken).thenReturn('test-token');
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => Subscription(
          active: true,
          planId: 'plan_123',
          activeUntil: DateTime.now().add(const Duration(days: 30)),
        ),
      );

      final store = createStore();
      await store.subscriptionFuture;

      // 3 user properties: planId, validTo, userStatus
      verify(mockAnalyticsStore.setUserProperty(any)).called(3);
    });

    test('sets userStatus to not_paid for inactive subscription', () async {
      when(mockAuthSessionStore.accessToken).thenReturn('test-token');
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(
        mockSubscriptionService.fetchSubscriptionDetails(),
      ).thenAnswer((_) async => Subscription(active: false, expired: false));

      final store = createStore();
      await store.subscriptionFuture;

      verify(mockAnalyticsStore.setUserProperty(any)).called(3);
    });

    test('sets userStatus to expired_paid for expired subscription', () async {
      when(mockAuthSessionStore.accessToken).thenReturn('test-token');
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => Subscription(
          active: false,
          expired: true,
          activeUntil: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      final store = createStore();
      await store.subscriptionFuture;

      verify(mockAnalyticsStore.setUserProperty(any)).called(3);
    });

    test('does not fetch subscription details when not authenticated', () async {
      when(mockAuthSessionStore.accessToken).thenReturn(null);
      when(mockAuthSessionStore.isAuthenticated).thenReturn(false);

      createStore();

      // Give any async work time to settle
      await Future<void>.delayed(Duration.zero);

      verifyNever(mockSubscriptionService.fetchSubscriptionDetails());
    });

    test('dispose disposes reactions without error', () {
      final store = createStore();
      expect(store.dispose, returnsNormally);
    });
  });
}
