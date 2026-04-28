import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_features_store.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'subscription_features_store_test.mocks.dart';

SubscriptionConfigResponsePlansInner _makePlan({required String id, bool? residentialIpsAllowed}) =>
    SubscriptionConfigResponsePlansInner(
      id: id,
      interval: SubscriptionConfigResponsePlansInnerInterval(
        unit: SubscriptionConfigResponsePlansInnerIntervalUnitEnum.month,
        amount: 1,
      ),
      price: SubscriptionConfigResponsePlansInnerPrice(USD: 500),
      prices: [],
      supportedGateways: [],
      metadata: SubscriptionConfigResponsePlansInnerMetadata(
        residentialIpsAllowed: residentialIpsAllowed,
      ),
    );

@GenerateNiceMocks([MockSpec<SubscriptionStore>(), MockSpec<SubscriptionConfigStore>()])
void main() {
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionConfigStore mockConfigStore;

  final activeSubscription = Subscription(
    active: true,
    expired: false,
    recurring: false,
    planId: 'basic',
  );

  setUp(() {
    mockSubscriptionStore = MockSubscriptionStore();
    mockConfigStore = MockSubscriptionConfigStore();

    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
    when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));
    when(mockConfigStore.subscriptionPlanFuture).thenAnswer(
      (_) => ObservableFuture.value(
        GetPlanResponse(id: '', description: '', metadata: PlanMetadata()),
      ),
    );
  });

  group('SubscriptionFeaturesStore', () {
    test('residentialIPsAllowed defaults to false when config is null', () {
      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(store.residentialIPsAllowed, false);
    });

    test('residentialIPsAllowed defaults to false when plan is not found in config', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'premium', residentialIpsAllowed: true)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      // 'basic' plan not in config → metadata is null → defaults to false
      expect(store.residentialIPsAllowed, false);
    });

    test('residentialIPsAllowed returns false from plan metadata', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'basic', residentialIpsAllowed: false)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(store.residentialIPsAllowed, false);
    });

    test('residentialIPsAllowed returns true when plan metadata allows it', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'basic', residentialIpsAllowed: true)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(store.residentialIPsAllowed, true);
    });

    test('residentialIPsAllowed falls back to plan metadata when config is null', () {
      when(mockConfigStore.subscriptionPlanFuture).thenAnswer(
        (_) => ObservableFuture.value(
          GetPlanResponse(
            id: 'basic',
            description: '',
            metadata: PlanMetadata(residentialIpsAllowed: true),
          ),
        ),
      );

      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(store.residentialIPsAllowed, true);
    });

    test('residentialIPsAllowed defaults to false when metadata field is null', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        // residentialIpsAllowed is null in metadata
        plans: [_makePlan(id: 'basic')],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(store.residentialIPsAllowed, false);
    });
  });
}
