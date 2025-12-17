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
])
void main() {
  late SubscriptionStore subscriptionStore;
  late MockSubscriptionService mockSubscriptionService;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockAnalyticsStore mockAnalyticsStore;

  final subscriptionExpired = Subscription(
    active: false,
    activeUntil: DateTime.now().subtract(const Duration(days: 1)),
    expired: true,
    recurring: false,
  );

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
    mockAuthSessionStore = MockAuthSessionStore();
    mockAnalyticsStore = MockAnalyticsStore();
    when(mockSubscriptionService.fetchSubscriptionDetails())
        .thenAnswer((_) async => subscriptionExpired);
    subscriptionStore = SubscriptionStore(
      subscriptionService: mockSubscriptionService,
      authSessionStore: mockAuthSessionStore,
      analyticsStore: mockAnalyticsStore,
    );
  });

  group('SubscriptionStore', () {
    test('fetches subscription config successfully', () async {
      final config = vpn_api.SubscriptionConfigResponse(
        gateways: [],
        plans: [],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer((_) async => config);
      when(mockSubscriptionService.clearPendingTransactions()).thenAnswer((_) async {});

      await subscriptionStore.refreshSubscriptionConfig();

      expect(subscriptionStore.storeState, StoreState.available);
    });

    test('handles subscription config fetch failure', () async {
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenThrow(NotAvailableException());

      await expectLater(
        subscriptionStore.refreshSubscriptionConfig(),
        completion(isNull),
      );

      expect(subscriptionStore.storeState, StoreState.notAvailable);
    });
  });
}
