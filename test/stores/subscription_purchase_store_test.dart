import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/subscription_required_exception.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:mysterium_vpn/stores/subscription_purchase_store.dart';
import 'package:talker/talker.dart';

import 'subscription_purchase_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InAppPurchase>(),
  MockSpec<SecureStorageService>(),
  MockSpec<SubscriptionService>(),
  MockSpec<Talker>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionPlansStore>(),
  MockSpec<ProductDetails>(),
  MockSpec<PurchasableProduct>(),
])
void main() {
  late MockInAppPurchase inAppPurchase;
  late MockSecureStorageService storage;
  late MockSubscriptionService service;
  late MockTalker logger;
  late MockAnalyticsStore analytics;
  late MockAuthSessionStore session;
  late MockSubscriptionStore subscriptions;
  late MockSubscriptionPlansStore plans;
  late SubscriptionPurchaseStore store;

  late MockProductDetails productDetails;

  final user = AuthUser(userId: 'u1', username: 'u@e.com');
  final activeSub = Subscription(
    active: true,
    planId: 'plan_monthly',
    gateway: 'stripe',
    expired: false,
    recurring: true,
  );
  final inactiveSub = Subscription(active: false, expired: false, recurring: false);

  setUp(() {
    inAppPurchase = MockInAppPurchase();
    storage = MockSecureStorageService();
    service = MockSubscriptionService();
    logger = MockTalker();
    analytics = MockAnalyticsStore();
    session = MockAuthSessionStore();
    subscriptions = MockSubscriptionStore();
    plans = MockSubscriptionPlansStore();
    productDetails = MockProductDetails();

    when(productDetails.id).thenReturn('plan_monthly');
    when(productDetails.rawPrice).thenReturn(9.99);
    when(productDetails.currencyCode).thenReturn('USD');

    // Construction subscribes to purchaseStream — provide an empty stream.
    when(inAppPurchase.purchaseStream).thenAnswer((_) => const Stream.empty());

    when(session.userFuture).thenAnswer((_) => ObservableFuture.value(user));
    when(subscriptions.subscriptionFuture).thenAnswer((_) => ObservableFuture.value(activeSub));
    when(plans.future).thenAnswer((_) => ObservableFuture.value(<PurchasableProduct>[]));
    when(plans.refresh()).thenAnswer((_) async => <PurchasableProduct>[]);

    when(
      service.subscribeToPackage(
        productDetails: anyNamed('productDetails'),
        purchasedProductId: anyNamed('purchasedProductId'),
        userId: anyNamed('userId'),
      ),
    ).thenAnswer((_) async {});
    when(
      service.manageSubscription(
        productDetails: anyNamed('productDetails'),
        userId: anyNamed('userId'),
      ),
    ).thenAnswer((_) async {});
    when(service.clearPendingTransactions()).thenAnswer((_) async {});

    store = SubscriptionPurchaseStore(
      inAppPurchase,
      storage,
      service,
      logger,
      analytics,
      session,
      subscriptions,
      plans,
    );
  });

  group('subscribeToPackage', () {
    test('happy path: invokes service and clears status', () async {
      await store.subscribeToPackage(product: productDetails);

      verify(
        service.subscribeToPackage(
          productDetails: productDetails,
          purchasedProductId: anyNamed('purchasedProductId'),
          userId: 'u1',
        ),
      ).called(1);
      verify(
        analytics.logEvent(AnalyticsEvent.returnStore, parameters: anyNamed('parameters')),
      ).called(1);
      expect(store.subscriptionStatus, isNull);
    });

    test('storekit2 cancellation sets status to canceled', () async {
      when(
        service.subscribeToPackage(
          productDetails: anyNamed('productDetails'),
          purchasedProductId: anyNamed('purchasedProductId'),
          userId: anyNamed('userId'),
        ),
      ).thenThrow(PlatformException(code: 'storekit2_purchase_cancelled'));

      await store.subscribeToPackage(product: productDetails);

      expect(store.subscriptionStatus, SubscriptionStatus.canceled);
      verifyNever(service.clearPendingTransactions());
    });

    test('generic error sets status to error and logs', () async {
      when(
        service.subscribeToPackage(
          productDetails: anyNamed('productDetails'),
          purchasedProductId: anyNamed('purchasedProductId'),
          userId: anyNamed('userId'),
        ),
      ).thenThrow(Exception('network'));

      await store.subscribeToPackage(product: productDetails);

      expect(store.subscriptionStatus, SubscriptionStatus.error);
      expect(store.subscriptionError, isA<Exception>());
      verify(service.clearPendingTransactions()).called(1);
      verify(
        analytics.logEvent(AnalyticsEvent.subscriptionError, parameters: anyNamed('parameters')),
      ).called(1);
    });
  });

  group('redeemCode', () {
    test('returns silently on non-iOS hosts and skips analytics', () async {
      // Tests run on the host (macOS / linux), so Platform.isIOS is false and
      // the method is expected to short-circuit.
      await store.redeemCode();

      verifyNever(analytics.logEvent(AnalyticsEvent.redeemOpen));
      verifyNever(analytics.logEvent(AnalyticsEvent.redeemCodeOpenSuccess));
    });
  });

  group('retryVerificationProcess', () {
    test('returns silently when there is no last purchase', () async {
      await store.retryVerificationProcess();

      verifyNever(subscriptions.updateSubscription(any));
    });
  });

  group('manageSubscription', () {
    test('happy path delegates to subscriptionService', () async {
      final product = MockPurchasableProduct();
      when(product.id).thenReturn('plan_monthly');
      when(product.productDetails).thenReturn(productDetails);
      when(plans.future).thenAnswer((_) => ObservableFuture.value([product]));

      await store.manageSubscription();

      verify(service.manageSubscription(productDetails: productDetails, userId: 'u1')).called(1);
    });

    test('throws SubscriptionRequiredException when not subscribed', () async {
      when(subscriptions.subscriptionFuture).thenAnswer((_) => ObservableFuture.value(inactiveSub));

      await expectLater(store.manageSubscription(), throwsA(isA<SubscriptionRequiredException>()));
      verifyNever(
        service.manageSubscription(
          productDetails: anyNamed('productDetails'),
          userId: anyNamed('userId'),
        ),
      );
    });

    test('throws SubscriptionRequiredException when plan not in catalog', () async {
      when(plans.future).thenAnswer((_) => ObservableFuture.value(<PurchasableProduct>[]));
      when(plans.refresh()).thenAnswer((_) async => <PurchasableProduct>[]);

      await expectLater(store.manageSubscription(), throwsA(isA<SubscriptionRequiredException>()));
    });

    test('storekit2 cancellation is swallowed (no rethrow)', () async {
      final product = MockPurchasableProduct();
      when(product.id).thenReturn('plan_monthly');
      when(product.productDetails).thenReturn(productDetails);
      when(plans.future).thenAnswer((_) => ObservableFuture.value([product]));
      when(
        service.manageSubscription(
          productDetails: anyNamed('productDetails'),
          userId: anyNamed('userId'),
        ),
      ).thenThrow(PlatformException(code: 'storekit2_purchase_cancelled'));

      await expectLater(store.manageSubscription(), completes);
    });

    test('rethrows other errors', () async {
      final product = MockPurchasableProduct();
      when(product.id).thenReturn('plan_monthly');
      when(product.productDetails).thenReturn(productDetails);
      when(plans.future).thenAnswer((_) => ObservableFuture.value([product]));
      when(
        service.manageSubscription(
          productDetails: anyNamed('productDetails'),
          userId: anyNamed('userId'),
        ),
      ).thenThrow(Exception('boom'));

      await expectLater(store.manageSubscription(), throwsA(isA<Exception>()));
    });
  });
}
