import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_limited_time_offer_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/models/models.dart';

import 'subscription_limited_time_offer_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionPlansStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<PurchasableProduct>(),
])
void main() {
  late MockSubscriptionPlansStore mockPlansStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  setUp(() {
    mockPlansStore = MockSubscriptionPlansStore();
    mockRemoteConfigStore = MockRemoteConfigStore();

    // Safe defaults
    when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn(null);
    when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(null);
    when(
      mockRemoteConfigStore.configFuture,
    ).thenAnswer((_) => ObservableFuture.value(const <String, dynamic>{}));
    when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value(const []));
  });

  SubscriptionLimitedTimeOfferStore createStore() =>
      SubscriptionLimitedTimeOfferStore(mockPlansStore, mockRemoteConfigStore);

  group('SubscriptionLimitedTimeOfferStore', () {
    test('returns null when expiryDate is null', () async {
      when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(null);
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_1');

      final store = createStore();
      final result = await store.future;

      expect(result, isNull);
    });

    test('returns null when expiryDate is in the past', () async {
      when(
        mockRemoteConfigStore.limitedTimeOfferExpiryDate,
      ).thenReturn(DateTime.now().subtract(const Duration(days: 1)));
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_1');

      final store = createStore();
      final result = await store.future;

      expect(result, isNull);
    });

    test('returns null when no product has matching offer', () async {
      final futureDate = DateTime.now().add(const Duration(days: 7));
      when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(futureDate);
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_nonexistent');

      final product = MockPurchasableProduct();
      when(product.duration).thenReturn(12);
      when(product.offers).thenReturn([
        ProductOffer(
          id: 'other_offer',
          price: 49.99,
          durationUnit: OfferDuration.month,
          durationValue: 1,
          fullPrice: 100,
        ),
      ]);

      when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value([product]));

      final store = createStore();
      final result = await store.future;

      expect(result, isNull);
    });

    test('returns matching offer from product with longest duration first', () async {
      final futureDate = DateTime.now().add(const Duration(days: 7));
      when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(futureDate);
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_1');

      final monthlyProduct = MockPurchasableProduct();
      when(monthlyProduct.duration).thenReturn(1);
      when(monthlyProduct.offers).thenReturn([
        ProductOffer(
          id: 'offer_1',
          price: 9.99,
          durationUnit: OfferDuration.month,
          durationValue: 1,
          fullPrice: 20,
        ),
      ]);

      final yearlyProduct = MockPurchasableProduct();
      when(yearlyProduct.duration).thenReturn(12);
      when(yearlyProduct.offers).thenReturn([
        ProductOffer(
          id: 'offer_1',
          price: 49.99,
          durationUnit: OfferDuration.year,
          durationValue: 1,
          fullPrice: 100,
        ),
      ]);

      when(
        mockPlansStore.future,
      ).thenAnswer((_) => ObservableFuture.value([monthlyProduct, yearlyProduct]));

      final store = createStore();
      final result = await store.future;

      expect(result, isNotNull);
      // Should pick yearly product (longest duration first due to reversed sort)
      expect(result!.product, equals(yearlyProduct));
      expect(result.offer.id, equals('offer_1'));
      expect(result.expiryDate, equals(futureDate));
    });

    test('picks cheapest matching offer when multiple offers match', () async {
      final futureDate = DateTime.now().add(const Duration(days: 7));
      when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(futureDate);
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_1');

      final product = MockPurchasableProduct();
      when(product.duration).thenReturn(12);
      when(product.offers).thenReturn([
        ProductOffer(
          id: 'offer_1',
          price: 99.99,
          durationUnit: OfferDuration.year,
          durationValue: 1,
          fullPrice: 200,
        ),
        ProductOffer(
          id: 'offer_1',
          price: 49.99,
          durationUnit: OfferDuration.year,
          durationValue: 1,
          fullPrice: 200,
        ),
      ]);

      when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value([product]));

      final store = createStore();
      final result = await store.future;

      expect(result, isNotNull);
      expect(result!.offer.price, equals(49.99));
    });

    test('discountPercent returns 0 when future is null', () async {
      final store = createStore();
      await store.future;

      expect(store.discountPercent, equals(0));
    });

    test('discountPercent returns offer discount when future has value', () async {
      final futureDate = DateTime.now().add(const Duration(days: 7));
      when(mockRemoteConfigStore.limitedTimeOfferExpiryDate).thenReturn(futureDate);
      when(mockRemoteConfigStore.limitedTimeOfferId).thenReturn('offer_1');

      final product = MockPurchasableProduct();
      when(product.duration).thenReturn(12);
      when(product.offers).thenReturn([
        ProductOffer(
          id: 'offer_1',
          price: 50,
          durationUnit: OfferDuration.year,
          durationValue: 1,
          fullPrice: 100,
        ),
      ]);

      when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value([product]));

      final store = createStore();
      await store.future;

      expect(store.discountPercent, equals(50));
    });

    test('dispose disposes reactions without error', () {
      final store = createStore();
      expect(store.dispose, returnsNormally);
    });
  });
}
