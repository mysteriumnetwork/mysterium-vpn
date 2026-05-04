import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_limited_time_offer_store.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';

import 'subscription_limited_time_offer_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteConfigStore>(),
  MockSpec<SubscriptionPlansStore>(),
  MockSpec<PurchasableProduct>(),
])
void main() {
  late MockRemoteConfigStore remoteConfig;
  late MockSubscriptionPlansStore plans;
  late MockPurchasableProduct product;

  setUp(() {
    remoteConfig = MockRemoteConfigStore();
    plans = MockSubscriptionPlansStore();
    product = MockPurchasableProduct();

    when(remoteConfig.configFuture).thenAnswer((_) => ObservableFuture.value({}));
    when(remoteConfig.limitedTimeOfferId).thenReturn(null);
    when(remoteConfig.limitedTimeOfferExpiryDate).thenReturn(null);
    when(plans.future).thenAnswer((_) => ObservableFuture.value(<PurchasableProduct>[]));
    when(product.duration).thenReturn(1);
    when(product.offers).thenReturn(<ProductOffer>[]);
  });

  SubscriptionLimitedTimeOfferStore newStore() =>
      SubscriptionLimitedTimeOfferStore(plans, remoteConfig);

  test('returns 0 discount when no offer is configured', () async {
    final store = newStore();
    await store.future;

    expect(store.discountPercent, 0);
    expect(store.future.value, isNull);
  });

  test('returns null offer when expiry date is in the past', () async {
    when(remoteConfig.limitedTimeOfferId).thenReturn('summer-sale');
    when(
      remoteConfig.limitedTimeOfferExpiryDate,
    ).thenReturn(DateTime.now().subtract(const Duration(days: 1)));

    final store = newStore();
    await store.future;

    expect(store.future.value, isNull);
  });

  test('mockOffer overrides the future with a fake limited-time offer', () async {
    when(plans.future).thenAnswer((_) => ObservableFuture.value([product]));

    final store = newStore();
    await store.future;
    await store.mockOffer();

    expect(store.future.value, isNotNull);
    expect(store.future.value!.offer.id, 'mock_offer');
  });

  test('dispose tears down reactions cleanly', () async {
    final store = newStore();
    await store.future;
    await store.dispose();
  });
}
