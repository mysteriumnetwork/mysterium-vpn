import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
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
  MockSpec<PurchasableProduct>(),
])
void main() {
  late MockInAppPurchase mockInAppPurchase;
  late MockSecureStorageService mockSecureStorage;
  late MockSubscriptionService mockSubscriptionService;
  late MockTalker mockTalker;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockSubscriptionStore mockSubscriptionStore;
  late MockSubscriptionPlansStore mockPlansStore;
  late StreamController<List<PurchaseDetails>> purchaseStreamController;

  setUp(() {
    mockInAppPurchase = MockInAppPurchase();
    mockSecureStorage = MockSecureStorageService();
    mockSubscriptionService = MockSubscriptionService();
    mockTalker = MockTalker();
    mockAnalyticsStore = MockAnalyticsStore();
    mockAuthSessionStore = MockAuthSessionStore();
    mockSubscriptionStore = MockSubscriptionStore();
    mockPlansStore = MockSubscriptionPlansStore();
    purchaseStreamController = StreamController<List<PurchaseDetails>>.broadcast();

    // Safe defaults for IAP stream
    when(mockInAppPurchase.purchaseStream).thenAnswer((_) => purchaseStreamController.stream);

    // Default auth user
    when(mockAuthSessionStore.userFuture).thenAnswer(
      (_) => ObservableFuture.value(AuthUser(userId: 'user_1', username: 'test@test.com')),
    );
    when(
      mockAuthSessionStore.user,
    ).thenReturn(AuthUser(userId: 'user_1', username: 'test@test.com'));

    // Default subscription
    when(
      mockSubscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    // Default plans
    when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value(const []));
  });

  tearDown(() {
    purchaseStreamController.close();
  });

  SubscriptionPurchaseStore createStore() => SubscriptionPurchaseStore(
    mockInAppPurchase,
    mockSecureStorage,
    mockSubscriptionService,
    mockTalker,
    mockAnalyticsStore,
    mockAuthSessionStore,
    mockSubscriptionStore,
    mockPlansStore,
  );

  group('SubscriptionPurchaseStore', () {
    test('initial subscriptionStatus is null', () {
      final store = createStore();
      expect(store.subscriptionStatus, isNull);
    });

    test('initial subscriptionError is null', () {
      final store = createStore();
      expect(store.subscriptionError, isNull);
    });

    test('initial lastPurchase is null', () {
      final store = createStore();
      expect(store.lastPurchase, isNull);
    });

    group('subscribeToPackage', () {
      test('sets status to pending and calls subscriptionService', () async {
        final product = MockPurchasableProduct();
        when(product.id).thenReturn('plan_123');
        when(product.duration).thenReturn(12);
        final productDetails = FakeProductDetails();
        when(product.productDetails).thenReturn(productDetails);

        when(
          mockSubscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
        when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value([product]));
        when(
          mockSubscriptionService.subscribeToPackage(
            productDetails: anyNamed('productDetails'),
            purchasedProductId: anyNamed('purchasedProductId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => null);

        final store = createStore();
        await store.subscribeToPackage(product: productDetails);

        verify(
          mockSubscriptionService.subscribeToPackage(
            productDetails: productDetails,
            purchasedProductId: null,
            userId: 'user_1',
          ),
        ).called(1);
        verify(
          mockAnalyticsStore.logEvent(
            AnalyticsEvent.returnStore,
            parameters: anyNamed('parameters'),
          ),
        ).called(1);
      });

      test('handles errors and sets status to error', () async {
        final productDetails = FakeProductDetails();

        when(
          mockSubscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
        when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value(const []));
        when(
          mockSubscriptionService.subscribeToPackage(
            productDetails: anyNamed('productDetails'),
            purchasedProductId: anyNamed('purchasedProductId'),
            userId: anyNamed('userId'),
          ),
        ).thenThrow(Exception('Purchase failed'));
        when(mockSubscriptionService.clearPendingTransactions()).thenAnswer((_) async => null);

        final store = createStore();
        await store.subscribeToPackage(product: productDetails);

        expect(store.subscriptionStatus, equals(SubscriptionStatus.error));
        expect(store.subscriptionError, isA<Exception>());
      });

      test('passes purchasedProductId for google gateway upgrades', () async {
        final existingProduct = MockPurchasableProduct();
        when(existingProduct.id).thenReturn('plan_old');
        when(existingProduct.duration).thenReturn(1);
        final existingProductDetails = FakeProductDetails(id: 'plan_old_store');
        when(existingProduct.productDetails).thenReturn(existingProductDetails);

        final newProductDetails = FakeProductDetails(id: 'plan_new_store');

        when(mockSubscriptionStore.subscriptionFuture).thenAnswer(
          (_) => ObservableFuture.value(
            Subscription(
              active: true,
              planId: 'plan_old',
              gateway: 'google',
              storePlanId: 'plan_old_store',
              activeUntil: DateTime.now().add(const Duration(days: 30)),
            ),
          ),
        );
        when(mockPlansStore.future).thenAnswer((_) => ObservableFuture.value([existingProduct]));
        when(
          mockSubscriptionService.subscribeToPackage(
            productDetails: anyNamed('productDetails'),
            purchasedProductId: anyNamed('purchasedProductId'),
            userId: anyNamed('userId'),
          ),
        ).thenAnswer((_) async => null);

        final store = createStore();
        await store.subscribeToPackage(product: newProductDetails);

        verify(
          mockSubscriptionService.subscribeToPackage(
            productDetails: newProductDetails,
            purchasedProductId: 'plan_old_store',
            userId: 'user_1',
          ),
        ).called(1);
      });
    });

    group('retryVerificationProcess', () {
      test('does nothing when lastPurchase is null', () async {
        final store = createStore();
        await store.retryVerificationProcess();

        verifyNever(mockSubscriptionStore.updateSubscription(any));
      });
    });

    group('manageSubscription', () {
      test('throws SubscriptionRequiredException when subscription is inactive', () async {
        when(
          mockSubscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

        final store = createStore();

        expect(store.manageSubscription, throwsA(isA<Exception>()));
      });
    });

    test('dispose cancels purchase stream', () async {
      final store = createStore();
      await store.dispose();
      // Should not throw
    });
  });
}

class FakeProductDetails extends Fake implements ProductDetails {
  FakeProductDetails({this.id = 'fake_product'});

  @override
  final String id;

  @override
  String get title => 'Fake Product';

  @override
  String get description => 'A fake product for testing';

  @override
  String get price => r'$9.99';

  @override
  double get rawPrice => 9.99;

  @override
  String get currencyCode => 'USD';

  @override
  String get currencySymbol => r'$';
}
