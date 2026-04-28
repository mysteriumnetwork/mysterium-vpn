import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_features_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/models/models.dart';
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

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionConfigStore>(),
  MockSpec<SubscriptionConfigResponse>(),
  MockSpec<SubscriptionConfigResponsePlansInner>(),
  MockSpec<SubscriptionConfigResponsePlansInnerMetadata>(),
])
void main() {
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionConfigStore mockConfigStore;
  late SubscriptionFeaturesStore store;

  setUp(() {
    mockSubscriptionStore = MockSubscriptionStore();
    mockConfigStore = MockSubscriptionConfigStore();
    store = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);
  });

  group('metadata', () {
    test('returns null when subscription has no value', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      expect(store.metadata, isNull);
    });

    test('returns null when subscription planId is null', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true)));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      expect(store.metadata, isNull);
    });

    test('returns null when config has no matching plan', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, planId: 'plan_123')));

      final config = MockSubscriptionConfigResponse();
      final plan = MockSubscriptionConfigResponsePlansInner();
      when(plan.id).thenReturn('plan_other');
      when(config.plans).thenReturn([plan]);
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      expect(store.metadata, isNull);
    });

    test('returns metadata when config has matching plan', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, planId: 'plan_123')));

      final metadata = MockSubscriptionConfigResponsePlansInnerMetadata();
      final plan = MockSubscriptionConfigResponsePlansInner();
      when(plan.id).thenReturn('plan_123');
      when(plan.metadata).thenReturn(metadata);

      final config = MockSubscriptionConfigResponse();
      when(config.plans).thenReturn([plan]);
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      expect(store.metadata, equals(metadata));
    });
  });

  group('residentialIPsAllowed', () {
    test('returns false when metadata is null (default)', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      expect(store.residentialIPsAllowed, isFalse);
    });

    test('returns value from metadata when present', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, planId: 'plan_123')));

      final metadata = MockSubscriptionConfigResponsePlansInnerMetadata();
      when(metadata.residentialIpsAllowed).thenReturn(false);

      final plan = MockSubscriptionConfigResponsePlansInner();
      when(plan.id).thenReturn('plan_123');
      when(plan.metadata).thenReturn(metadata);

      final config = MockSubscriptionConfigResponse();
      when(config.plans).thenReturn([plan]);
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      expect(store.residentialIPsAllowed, isFalse);
    });
  });

  group('residentialIPsAllowed (concrete objects)', () {
    final activeSubscription = Subscription(
      active: true,
      expired: false,
      recurring: false,
      planId: 'basic',
    );

    test('defaults to false when config is null', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      final s = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(s.residentialIPsAllowed, false);
    });

    test('defaults to false when plan is not found in config', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'premium', residentialIpsAllowed: true)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final s = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(s.residentialIPsAllowed, false);
    });

    test('returns false from plan metadata', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'basic', residentialIpsAllowed: false)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final s = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(s.residentialIPsAllowed, false);
    });

    test('returns true when plan metadata allows it', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        plans: [_makePlan(id: 'basic', residentialIpsAllowed: true)],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final s = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(s.residentialIPsAllowed, true);
    });

    test('defaults to false when metadata field is null', () {
      final config = SubscriptionConfigResponse(
        gateways: [],
        // residentialIpsAllowed is null in metadata
        plans: [_makePlan(id: 'basic')],
        countries: [],
        stripeReturnUrl: '',
        stripePublishableKey: '',
      );
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(activeSubscription));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      final s = SubscriptionFeaturesStore(mockSubscriptionStore, mockConfigStore);

      expect(s.residentialIPsAllowed, false);
    });
  });

  group('malwareBlockingAllowed', () {
    test('returns false when metadata is null (default)', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      expect(store.malwareBlockingAllowed, isFalse);
    });

    test('returns value from metadata when present', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, planId: 'plan_123')));

      final metadata = MockSubscriptionConfigResponsePlansInnerMetadata();
      when(metadata.malwareBlockingAllowed).thenReturn(true);

      final plan = MockSubscriptionConfigResponsePlansInner();
      when(plan.id).thenReturn('plan_123');
      when(plan.metadata).thenReturn(metadata);

      final config = MockSubscriptionConfigResponse();
      when(config.plans).thenReturn([plan]);
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config));

      expect(store.malwareBlockingAllowed, isTrue);
    });
  });

  test('dispose does not throw', () {
    expect(() => store.dispose(), returnsNormally);
  });
}
