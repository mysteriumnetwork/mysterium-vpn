import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'subscription_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionService>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<InAppPurchase>(),
  MockSpec<PurchasableProduct>(),
  MockSpec<ProductDetails>(),
])
void main() {
  late SubscriptionStore subscriptionStore;
  late MockSubscriptionService mockSubscriptionService;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockInAppPurchase mockInAppPurchase;
  late MockPurchasableProduct mockPurchasableProduct;
  late MockProductDetails mockProductDetails;

  final subscriptionActive = Subscription(
    active: true,
    activeUntil: DateTime.now().add(const Duration(days: 1)),
    expired: false,
    recurring: true,
  );

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
    mockInAppPurchase = MockInAppPurchase();
    mockPurchasableProduct = MockPurchasableProduct();
    mockProductDetails = MockProductDetails();
    when(mockSubscriptionService.fetchSubscriptionDetails())
        .thenAnswer((_) async => subscriptionExpired);
    subscriptionStore = SubscriptionStore(
      inAppPurchase: mockInAppPurchase,
      subscriptionService: mockSubscriptionService,
      authSessionStore: mockAuthSessionStore,
      analyticsStore: mockAnalyticsStore,
    );
  });

  group('SubscriptionStore', () {
    test('fetches subscription details successfully', () async {
      when(mockSubscriptionService.fetchSubscriptionDetails())
          .thenAnswer((_) async => subscriptionActive);

      await expectLater(subscriptionStore.refreshSubscription(), completes);

      expect(subscriptionStore.isSubscribed, isTrue);
    });

    test('handles subscription fetch failure', () async {
      when(mockSubscriptionService.fetchSubscriptionDetails())
          .thenThrow(Exception('Failed to fetch subscription'));

      await expectLater(subscriptionStore.refreshSubscription(), throwsA(isException));
    });

    test('fetches subscription config successfully', () async {
      final config = SubscriptionConfigResponse(
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

    test('fetches products successfully', () async {
      when(mockPurchasableProduct.duration).thenReturn(1);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => subscriptionActive,
      );
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer(
        (_) async => SubscriptionConfigResponse(
          gateways: [],
          plans: [],
          countries: [],
          stripeReturnUrl: '',
          stripePublishableKey: '',
        ),
      );

      final products = [mockPurchasableProduct];
      when(mockSubscriptionService.getProductsDetails(any, any)).thenAnswer((_) async => products);

      await expectLater(subscriptionStore.refreshProducts(), completes);

      expect(subscriptionStore.monthlyProduct, isNotNull);
    });

    test('handles product fetch failure', () async {
      when(mockPurchasableProduct.duration).thenReturn(1);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => subscriptionActive,
      );
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer(
        (_) async => SubscriptionConfigResponse(
          gateways: [],
          plans: [],
          countries: [],
          stripeReturnUrl: '',
          stripePublishableKey: '',
        ),
      );
      when(mockSubscriptionService.getProductsDetails(any, any))
          .thenThrow(Exception('Failed to fetch products'));

      await expectLater(subscriptionStore.refreshProducts(), throwsA(isException));

      expect(subscriptionStore.monthlyProduct, isNull);
    });

    test('subscribes to package successfully', () async {
      when(mockProductDetails.id).thenReturn('product1');
      when(mockProductDetails.rawPrice).thenReturn(9.99);
      when(mockProductDetails.currencySymbol).thenReturn(r'$');
      when(mockProductDetails.currencyCode).thenReturn('USD');
      when(mockProductDetails.price).thenReturn(r'$9.99');

      when(mockAuthSessionStore.userFuture).thenAnswer(
        (_) => ObservableFuture.value(AuthUser(username: 'user1', userId: 'id1')),
      );

      when(
        mockSubscriptionService.subscribeToPackage(
          productDetails: mockProductDetails,
          purchasedProductId: mockProductDetails.id,
          userId: 'id1',
        ),
      ).thenAnswer((_) async => true);

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => subscriptionActive,
      );

      await expectLater(
        subscriptionStore.subscribeToPackage(product: mockProductDetails),
        completes,
      );

      expect(subscriptionStore.subscriptionStatus, SubscriptionStatus.pending);
    });

    test('handles subscription error', () async {
      when(mockProductDetails.id).thenReturn('product1');
      when(mockProductDetails.rawPrice).thenReturn(9.99);
      when(mockProductDetails.currencySymbol).thenReturn(r'$');
      when(mockProductDetails.currencyCode).thenReturn('USD');
      when(mockProductDetails.price).thenReturn(r'$9.99');

      when(mockAuthSessionStore.userFuture).thenAnswer(
        (_) => ObservableFuture.value(AuthUser(username: 'user1', userId: 'id1')),
      );

      when(mockPurchasableProduct.duration).thenReturn(1);
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
        (_) async => subscriptionActive,
      );
      when(mockSubscriptionService.fetchSubscriptionConfig()).thenAnswer(
        (_) async => SubscriptionConfigResponse(
          gateways: [],
          plans: [],
          countries: [],
          stripeReturnUrl: '',
          stripePublishableKey: '',
        ),
      );

      when(
        mockSubscriptionService.subscribeToPackage(
          productDetails: mockProductDetails,
          purchasedProductId: null,
          userId: 'id1',
        ),
      ).thenThrow(Exception('Subscription error'));

      await expectLater(
        subscriptionStore.subscribeToPackage(product: mockProductDetails),
        completes,
      );

      expect(subscriptionStore.subscriptionStatus, SubscriptionStatus.error);
    });
  });
}
