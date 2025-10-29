import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/subscription_upgrade_store.dart';

import 'subscription_upgrade_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionStore>(),
  MockSpec<PurchasableProduct>(),
  MockSpec<Subscription>(),
])
void main() {
  late MockSubscriptionStore mockSubscriptionStore;
  late MockPurchasableProduct prodA;
  late MockPurchasableProduct prodB;
  late MockPurchasableProduct prodC;
  late MockSubscription mockSubscription;
  late SubscriptionUpgradeStore store;

  setUp(() {
    mockSubscriptionStore = MockSubscriptionStore();
    prodA = MockPurchasableProduct();
    prodB = MockPurchasableProduct();
    prodC = MockPurchasableProduct();
    mockSubscription = MockSubscription();

    store = SubscriptionUpgradeStore(mockSubscriptionStore);
    when(mockSubscription.gateway).thenReturn('apple');
  });

  test('purchasableProducts are sorted by duration ascending', () async {
    when(prodA.duration).thenReturn(12);
    when(prodB.duration).thenReturn(6);
    when(mockSubscriptionStore.productsFuture)
        .thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    // access computed to ensure it reads the mocked future
    final result = store.purchasableProducts;

    expect(result, equals([prodB, prodA]));
  });

  test('currentProduct returns null when subscription gateway is off', () async {
    when(mockSubscriptionStore.subscriptionFuture)
        .thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(false);
    when(mockSubscriptionStore.productsFuture)
        .thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    final result = store.currentProduct;

    expect(result, isNull);
  });

  test('currentProduct picks product matching subscription planId when available and not expired',
      () async {
    when(mockSubscriptionStore.subscriptionFuture)
        .thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
    when(mockSubscription.isExpired).thenReturn(false);
    when(mockSubscription.planId).thenReturn('plan-b');

    when(prodA.id).thenReturn('plan-a');
    when(prodB.id).thenReturn('plan-b');
    when(mockSubscriptionStore.productsFuture)
        .thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    final result = store.currentProduct;

    expect(result, equals(prodB));
  });

  test('upgradeProduct returns last purchasable product when currentProduct is present', () async {
    when(mockSubscriptionStore.subscriptionFuture)
        .thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
    when(mockSubscription.isExpired).thenReturn(false);
    when(mockSubscription.planId).thenReturn('plan-a');

    when(prodA.id).thenReturn('plan-a');
    when(prodA.duration).thenReturn(1);
    when(prodB.duration).thenReturn(6);
    when(prodC.duration).thenReturn(12);

    when(mockSubscriptionStore.productsFuture)
        .thenAnswer((_) => ObservableFuture.value([prodA, prodB, prodC]));

    final result = store.upgradeProduct;

    expect(result, equals(prodC));
  });

  test('upgradeDiscountPercent uses current.periodDiscountPercentage(upgrade)', () async {
    when(mockSubscriptionStore.subscriptionFuture)
        .thenAnswer((_) => ObservableFuture.value(mockSubscription));
    when(mockSubscription.isGatewayOnCurrentPlatform).thenReturn(true);
    when(mockSubscription.isExpired).thenReturn(false);
    when(mockSubscription.planId).thenReturn('plan-a');

    when(prodA.id).thenReturn('plan-a');
    when(prodB.duration).thenReturn(6);
    when(prodA.duration).thenReturn(1);

    when(mockSubscriptionStore.productsFuture)
        .thenAnswer((_) => ObservableFuture.value([prodA, prodB]));

    when(prodA.periodDiscountPercentage(prodB)).thenReturn(42);

    // read computed values
    final percent = store.upgradeDiscountPercent;

    expect(percent, equals(42));
  });
}
