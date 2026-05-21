import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'subscription_plans_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionService>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<PurchasableProduct>(),
  MockSpec<SubscriptionPlanFeatures>(),
  MockSpec<InAppPurchase>(),
])
void main() {
  late MockSubscriptionService mockService;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockInAppPurchase mockInAppPurchase;
  late PurchasableProduct planBasicMonthly;
  late PurchasableProduct planBasicAnnual;
  late PurchasableProduct planPlusMonthly;
  late PurchasableProduct planPlusAnnual;
  late SubscriptionPlanFeatures featuresBasic;
  late SubscriptionPlanFeatures featuresPlus;

  setUp(() {
    mockService = MockSubscriptionService();
    mockSubscriptionStore = MockSubscriptionStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockInAppPurchase = MockInAppPurchase();

    when(mockInAppPurchase.isAvailable()).thenAnswer((_) async => true);
    planBasicMonthly = MockPurchasableProduct();
    planBasicAnnual = MockPurchasableProduct();
    planPlusAnnual = MockPurchasableProduct();
    planPlusMonthly = MockPurchasableProduct();
    featuresBasic = MockSubscriptionPlanFeatures();
    featuresPlus = MockSubscriptionPlanFeatures();

    when(planBasicMonthly.id).thenReturn('plan_monthly_basic');
    when(planBasicMonthly.duration).thenReturn(1);

    when(planBasicAnnual.id).thenReturn('plan_yearly_basic');
    when(planBasicAnnual.duration).thenReturn(12);

    when(planPlusMonthly.id).thenReturn('plan_monthly_plus');
    when(planPlusMonthly.duration).thenReturn(1);

    when(planPlusAnnual.id).thenReturn('plan_yearly_plus');
    when(planPlusAnnual.duration).thenReturn(12);

    when(featuresBasic.planIds).thenReturn({'plan_monthly_basic', 'plan_yearly_basic'});
    when(featuresPlus.planIds).thenReturn({'plan_monthly_plus', 'plan_yearly_plus'});

    // Default: remote config future already fulfilled.
    when(mockRemoteConfigStore.configFuture).thenAnswer((_) => ObservableFuture.value(const {}));

    // Default: avoid constructor reaction inside SubscriptionPlansStore triggering refresh().
    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    when(mockSubscriptionStore.subscriptionConfigFuture).thenAnswer(
      (_) => ObservableFuture.value(
        SubscriptionConfigResponse(
          gateways: [SubscriptionConfigResponseGatewaysInner(name: 'apple', enabled: true)],
          plans: [],
          countries: [],
        ),
      ),
    );

    when(
      mockService.getProductsDetails(any, any),
    ).thenAnswer((_) async => [planBasicMonthly, planBasicAnnual, planPlusMonthly, planPlusAnnual]);

    // Default selectors.
    when(mockRemoteConfigStore.planFeatures).thenReturn(const <SubscriptionPlanFeatures>[]);
    when(mockRemoteConfigStore.plansBestValue).thenReturn(const <String>{});
  });

  group('fetching', () {
    test('fetches all products successfully', () async {
      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      final products = await store.future;

      expect(products.length, 4);
      expect(
        products,
        containsAll([planBasicMonthly, planBasicAnnual, planPlusMonthly, planPlusAnnual]),
      );

      verify(mockService.getProductsDetails(any, any)).called(1);
    });

    test('returns empty list when store is not available', () async {
      when(mockInAppPurchase.isAvailable()).thenAnswer((_) async => false);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      final products = await store.future;

      expect(products, isEmpty);
      verifyNever(mockService.getProductsDetails(any, any));
    });

    test('returns empty list when subscription config not available', () async {
      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      when(
        mockSubscriptionStore.subscriptionConfigFuture,
      ).thenAnswer((_) => ObservableFuture.value(null));

      final products = await store.future;

      expect(products, isEmpty);

      verifyNever(mockService.getProductsDetails(any, any));
    });
  });

  group('computed properties', () {
    test('products filters products based on remote config plan features', () async {
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.products;

      expect(result, equals([planBasicMonthly, planBasicAnnual, planPlusMonthly, planPlusAnnual]));
    });

    test('monthlyProducts returns only monthly duration products', () async {
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.monthlyProducts;

      expect(result, equals([planBasicMonthly, planPlusMonthly]));
    });

    test('annualProducts returns only annual duration products', () async {
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.annualProducts;

      expect(result, equals([planBasicAnnual, planPlusAnnual]));
    });

    test('purchasedProduct returns product matching subscription planId', () async {
      when(mockSubscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(
            planId: 'plan_monthly_plus',
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
          ),
        ),
      );
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.purchasedProduct;

      expect(result, equals(planPlusMonthly));
    });

    test('purchasedProduct returns null when no matching product found', () async {
      when(mockSubscriptionStore.subscriptionFuture).thenAnswer(
        (_) => ObservableFuture.value(
          Subscription(
            planId: 'non_existent_plan',
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
          ),
        ),
      );
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.purchasedProduct;

      expect(result, isNull);
    });

    test('findConfig returns correct plan features for a product', () async {
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      final result = store.findConfig(planBasicMonthly);

      expect(result, equals(featuresBasic));
    });

    test('bestValueProducts returns products marked as best value', () async {
      when(mockRemoteConfigStore.planFeatures).thenReturn([featuresBasic, featuresPlus]);
      when(
        mockRemoteConfigStore.plansBestValue,
      ).thenReturn({'plan_yearly_plus', 'plan_yearly_basic'});

      final store = SubscriptionPlansStore(
        mockService,
        mockSubscriptionStore,
        mockRemoteConfigStore,
        mockInAppPurchase,
        testPlatformGateway: 'apple',
      );

      await store.future;

      // access computed to ensure it reads the mocked future
      final result = store.bestValueProducts;

      expect(result, equals([planBasicAnnual, planPlusAnnual]));
    });
  });
}
