import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';

import 'subscription_upgrade_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionPlansStore>(),
  MockSpec<PurchasableProduct>(),
  MockSpec<Subscription>(),
  MockSpec<SubscriptionPlanFeatures>(),
])
void main() {
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionPlansStore mockSubscriptionPlansStore;
  late MockPurchasableProduct prodA;
  late MockPurchasableProduct prodB;
  late MockPurchasableProduct prodC;
  late MockSubscription mockSubscription;
  late SubscriptionUpgradeStore store;

  setUp(() {
    mockSubscriptionStore = MockSubscriptionStore();
    mockSubscriptionPlansStore = MockSubscriptionPlansStore();
    prodA = MockPurchasableProduct();
    prodB = MockPurchasableProduct();
    prodC = MockPurchasableProduct();
    mockSubscription = MockSubscription();

    // Set up default IDs for all products to avoid null issues
    when(prodA.id).thenReturn('plan-a');
    when(prodB.id).thenReturn('plan-b');
    when(prodC.id).thenReturn('plan-c');

    store = SubscriptionUpgradeStore(mockSubscriptionStore, mockSubscriptionPlansStore);
    when(mockSubscription.gateway).thenReturn('apple');
  });

  test('purchasableProducts are sorted by duration ascending', () async {
    when(prodA.duration).thenReturn(12);
    when(prodB.duration).thenReturn(6);
    when(
      mockSubscriptionPlansStore.future,
    ).thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    // access computed to ensure it reads the mocked future
    final result = store.purchasableProducts;

    expect(result, equals([prodB, prodA]));
  });

  test('currentProduct returns null when subscription gateway is off', () async {
    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(false);
    when(
      mockSubscriptionPlansStore.future,
    ).thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    final result = store.currentProduct;

    expect(result, isNull);
  });

  test(
    'currentProduct picks product matching subscription planId when available and not expired',
    () async {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
      when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
      when(mockSubscription.isExpired).thenReturn(false);
      when(mockSubscription.planId).thenReturn('plan-b');

      when(prodA.id).thenReturn('plan-a');
      when(prodB.id).thenReturn('plan-b');
      when(
        mockSubscriptionPlansStore.future,
      ).thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

      final result = store.currentProduct;

      expect(result, equals(prodB));
    },
  );

  test('upgradeProduct returns last purchasable product when currentProduct is present', () async {
    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
    when(mockSubscription.isExpired).thenReturn(false);
    when(mockSubscription.planId).thenReturn('plan-a');

    when(prodA.id).thenReturn('plan-a');
    when(prodA.duration).thenReturn(1);
    when(prodB.duration).thenReturn(6);
    when(prodC.duration).thenReturn(12);

    when(
      mockSubscriptionPlansStore.future,
    ).thenAnswer((_) => ObservableFuture.value([prodA, prodB, prodC]));

    // Add stubs for findConfig calls - must stub ALL products in the list
    final configA = MockSubscriptionPlanFeatures();
    when(configA.name).thenReturn('PlanA');
    when(mockSubscriptionPlansStore.findConfig(prodA)).thenReturn(configA);
    when(mockSubscriptionPlansStore.findConfig(prodB)).thenReturn(configA);
    when(mockSubscriptionPlansStore.findConfig(prodC)).thenReturn(configA);

    // Mock bestValueProducts to return prodC as best value
    when(mockSubscriptionPlansStore.bestValueProducts).thenReturn([prodC]);

    final result = store.upgradeProduct;

    expect(result, equals(prodC));
  });

  test('upgradeDiscountPercent uses current.periodDiscountPercentage(upgrade)', () async {
    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
    when(mockSubscription.isExpired).thenReturn(false);
    when(mockSubscription.planId).thenReturn('plan-a');

    when(prodA.duration).thenReturn(1);
    when(prodB.duration).thenReturn(6);

    when(
      mockSubscriptionPlansStore.future,
    ).thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    // Add stubs for findConfig calls
    final configA = MockSubscriptionPlanFeatures();
    when(configA.name).thenReturn('PlanA');
    when(mockSubscriptionPlansStore.findConfig(prodA)).thenReturn(configA);
    when(mockSubscriptionPlansStore.findConfig(prodB)).thenReturn(configA);

    // Mock bestValueProducts - should return prodB as best value for upgrade
    when(mockSubscriptionPlansStore.bestValueProducts).thenReturn([prodB]);

    when(prodA.periodDiscountPercentage(prodB)).thenReturn(42);

    // read computed values
    final percent = store.upgradeDiscountPercent;

    expect(percent, equals(42));
  });

  group('getComparisonProduct', () {
    late MockPurchasableProduct basicMonthly;
    late MockPurchasableProduct basicYearly;
    late MockPurchasableProduct plusMonthly;
    late MockPurchasableProduct plusYearly;

    setUp(() {
      basicMonthly = MockPurchasableProduct();
      basicYearly = MockPurchasableProduct();
      plusMonthly = MockPurchasableProduct();
      plusYearly = MockPurchasableProduct();

      // Set up product IDs
      when(basicMonthly.id).thenReturn('basic-monthly');
      when(basicYearly.id).thenReturn('basic-yearly');
      when(plusMonthly.id).thenReturn('plus-monthly');
      when(plusYearly.id).thenReturn('plus-yearly');

      // Set up durations
      when(basicMonthly.duration).thenReturn(1);
      when(basicYearly.duration).thenReturn(12);
      when(plusMonthly.duration).thenReturn(1);
      when(plusYearly.duration).thenReturn(12);
    });

    test('no current plan + yearly product returns monthly of same tier', () {
      final noActiveSub = MockSubscription();
      when(noActiveSub.isGatewayOnCurrentPlatform).thenReturn(false);
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(noActiveSub));
      when(mockSubscriptionPlansStore.future).thenAnswer(
        (_) => ObservableFuture.value([basicMonthly, basicYearly, plusMonthly, plusYearly]),
      );

      final basicConfig = MockSubscriptionPlanFeatures();
      when(basicConfig.name).thenReturn('Basic');
      when(mockSubscriptionPlansStore.findConfig(basicYearly)).thenReturn(basicConfig);
      when(mockSubscriptionPlansStore.findConfig(basicMonthly)).thenReturn(basicConfig);

      final result = store.getComparisonProduct(basicYearly, [
        basicMonthly,
        basicYearly,
        plusMonthly,
        plusYearly,
      ]);

      expect(result, equals(basicMonthly));
    });

    test('no current plan + monthly product returns null', () {
      final noActiveSub = MockSubscription();
      when(noActiveSub.isGatewayOnCurrentPlatform).thenReturn(false);
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(noActiveSub));
      when(
        mockSubscriptionPlansStore.future,
      ).thenAnswer((_) => ObservableFuture.value([basicMonthly, basicYearly]));

      final basicConfig = MockSubscriptionPlanFeatures();
      when(basicConfig.name).thenReturn('Basic');
      when(mockSubscriptionPlansStore.findConfig(basicMonthly)).thenReturn(basicConfig);

      final result = store.getComparisonProduct(basicMonthly, [basicMonthly, basicYearly]);

      expect(result, isNull);
    });

    test('current monthly plan + viewing yearly same tier returns current plan', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
      when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
      when(mockSubscription.isExpired).thenReturn(false);
      when(mockSubscription.planId).thenReturn('basic-monthly');

      when(mockSubscriptionPlansStore.future).thenAnswer(
        (_) => ObservableFuture.value([basicMonthly, basicYearly, plusMonthly, plusYearly]),
      );

      // Store needs to find the config, we'll mock the findConfig method
      final basicConfig = MockSubscriptionPlanFeatures();
      when(basicConfig.name).thenReturn('Basic');
      when(mockSubscriptionPlansStore.findConfig(basicMonthly)).thenReturn(basicConfig);
      when(mockSubscriptionPlansStore.findConfig(basicYearly)).thenReturn(basicConfig);

      final result = store.getComparisonProduct(basicYearly, [
        basicMonthly,
        basicYearly,
        plusMonthly,
        plusYearly,
      ]);

      expect(result, equals(basicMonthly));
    });

    test('current yearly plan + viewing yearly returns current plan', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
      when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
      when(mockSubscription.isExpired).thenReturn(false);
      when(mockSubscription.planId).thenReturn('basic-yearly');

      when(mockSubscriptionPlansStore.future).thenAnswer(
        (_) => ObservableFuture.value([basicMonthly, basicYearly, plusMonthly, plusYearly]),
      );

      final basicConfig = MockSubscriptionPlanFeatures();
      when(basicConfig.name).thenReturn('Basic');
      when(mockSubscriptionPlansStore.findConfig(basicYearly)).thenReturn(basicConfig);

      final result = store.getComparisonProduct(plusYearly, [
        basicMonthly,
        basicYearly,
        plusMonthly,
        plusYearly,
      ]);

      expect(result, equals(basicYearly));
    });

    test('current plan + viewing different tier returns current plan', () {
      when(
        mockSubscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(mockSubscription));
      when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
      when(mockSubscription.isExpired).thenReturn(false);
      when(mockSubscription.planId).thenReturn('basic-monthly');

      when(mockSubscriptionPlansStore.future).thenAnswer(
        (_) => ObservableFuture.value([basicMonthly, basicYearly, plusMonthly, plusYearly]),
      );

      final basicConfig = MockSubscriptionPlanFeatures();
      when(basicConfig.name).thenReturn('Basic');
      when(mockSubscriptionPlansStore.findConfig(basicMonthly)).thenReturn(basicConfig);

      final plusConfig = MockSubscriptionPlanFeatures();
      when(plusConfig.name).thenReturn('Plus');
      when(mockSubscriptionPlansStore.findConfig(plusMonthly)).thenReturn(plusConfig);

      final result = store.getComparisonProduct(plusMonthly, [
        basicMonthly,
        basicYearly,
        plusMonthly,
        plusYearly,
      ]);

      expect(result, equals(basicMonthly));
    });
  });
}
