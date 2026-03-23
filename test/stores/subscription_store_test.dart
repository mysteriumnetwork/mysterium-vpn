// dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart' as vpn_api;

import 'subscription_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionService>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late SubscriptionStore subscriptionStore;
  late MockSubscriptionService mockSubscriptionService;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  final subscriptionExpired = Subscription(
    active: false,
    activeUntil: DateTime.now().subtract(const Duration(days: 1)),
    expired: true,
    recurring: false,
  );

  vpn_api.SubscriptionConfigResponse config() => vpn_api.SubscriptionConfigResponse(
        gateways: [],
        plans: [],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
    mockAuthSessionStore = MockAuthSessionStore();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();

    when(mockRemoteConfigStore.hideReedemCode).thenReturn(false);
    when(mockAuthSessionStore.isAuthenticated).thenReturn(false);
    when(mockSubscriptionService.fetchSubscriptionDetails())
        .thenAnswer((_) async => subscriptionExpired);

    // Make constructor-time config fetch safe/deterministic.
    when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer((_) async => config());
    when(mockSubscriptionService.clearPendingTransactions()).thenAnswer((_) async {});

    subscriptionStore = SubscriptionStore(
      subscriptionService: mockSubscriptionService,
      authSessionStore: mockAuthSessionStore,
      analyticsStore: mockAnalyticsStore,
      remoteConfigStore: mockRemoteConfigStore,
    );

    clearInteractions(mockSubscriptionService);
    clearInteractions(mockAuthSessionStore);
    clearInteractions(mockAnalyticsStore);
  });

  group('SubscriptionStore', () {
    test('fetches subscription config successfully', () async {
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer((_) async => config());

      await subscriptionStore.refreshSubscriptionConfig();

      expect(subscriptionStore.storeState, StoreState.available);

      // `replaceOrReset` may call the supplier more than once; do not assert exact count.
      verify(mockSubscriptionService.fetchSubscriptionConfig()).called(greaterThan(0));
      verify(mockSubscriptionService.clearPendingTransactions()).called(greaterThan(0));
    });

    test('handles subscription config fetch failure (NotAvailableException)', () async {
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenThrow(NotAvailableException());

      await subscriptionStore.refreshSubscriptionConfig();

      expect(subscriptionStore.storeState, StoreState.notAvailable);

      verify(mockSubscriptionService.fetchSubscriptionConfig()).called(greaterThan(0));
      verifyNever(mockSubscriptionService.clearPendingTransactions());
    });

    test('refreshSubscription triggers fetch when last value is inactive', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      // First refresh returns inactive, second returns active.
      final inactive = Subscription(
        active: false,
        activeUntil: DateTime.now().subtract(const Duration(days: 1)),
        expired: true,
        recurring: false,
      );
      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => inactive);
      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, false);

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);
      await subscriptionStore.refreshSubscription();

      expect(subscriptionStore.isSubscribed, true);
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(2);
    });

    test('refreshSubscription does not refetch when already active and not rejected', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);

      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, true);

      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, true);

      // Only the initial call should happen; second refresh should not refetch.
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(1);
    });

    test('mockSubscriptionFailureStatus makes refreshSubscription refetch', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      subscriptionStore.mockSubscriptionFailureStatus();

      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);

      await subscriptionStore.refreshSubscription();

      expect(subscriptionStore.isSubscribed, true);
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(1);
    });

    test(
      'refreshSubscription sets analytics user properties for planId, validTo, userStatus',
      () async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

        final paid = Subscription(
          active: true,
          activeUntil: DateTime.now().add(const Duration(days: 7)),
          expired: false,
          recurring: true,
          planId: 'plan_123',
        );
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => paid);

        await subscriptionStore.refreshSubscription();

        // The exact object shape for AnalyticsUserProperty is internal; verify calls count.
        verify(mockAnalyticsStore.setUserProperty(any)).called(3);
      },
    );

    group('canRedeemCode', () {
      test('returns false when hideReedemCode remote config is true', () async {
        subscriptionStore.testIsIOS = true;
        when(mockRemoteConfigStore.hideReedemCode).thenReturn(true);

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns false on non-iOS platform', () async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription.empty(),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns true when no active subscription on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription.empty(),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns true when active subscription with apple gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
            gateway: 'apple',
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns false when active subscription with non-apple gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
            gateway: 'stripe',
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns false when active subscription with null gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });
    });
  });
}
