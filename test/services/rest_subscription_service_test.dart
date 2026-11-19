import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/repositories/subscription/rest_subscription_repository.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart' as api;

import 'rest_subscription_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SecureStorageService>(),
  MockSpec<api.VpnApi>(),
  MockSpec<api.Subscription>(),
  MockSpec<InAppPurchase>(),
  MockSpec<Talker>(),
])
void main() {
  late MockVpnApi vpnApi;
  late MockSubscription apiSubscription;
  late MockInAppPurchase inAppPurchase;
  late MockTalker logger;
  late RestSubscriptionRepository service;

  setUp(() {
    vpnApi = MockVpnApi();
    apiSubscription = MockSubscription();
    inAppPurchase = MockInAppPurchase();
    logger = MockTalker();

    when(vpnApi.getSubscription()).thenReturn(apiSubscription);

    service = RestSubscriptionRepository(
      api: vpnApi,
      inAppPurchase: inAppPurchase,
      logger: logger,
      secureStorage: MockSecureStorageService(),
    );
  });

  Response<T> response<T>(int code, T data) =>
      Response<T>(requestOptions: RequestOptions(), statusCode: code, data: data);

  group('androidManageSubscriptionUrl', () {
    test('builds the Play Store subscriptions deep link for the product', () async {
      PackageInfo.setMockInitialValues(
        appName: 'Mysterium VPN',
        packageName: 'com.mysteriumvpn.android',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      final url = await service.androidManageSubscriptionUrl('plan_monthly');

      expect(url.host, 'play.google.com');
      expect(url.path, '/store/account/subscriptions');
      expect(url.queryParameters['sku'], 'plan_monthly');
      expect(url.queryParameters['package'], 'com.mysteriumvpn.android');
    });
  });

  group('fetchSubscriptionDetails', () {
    test('maps a populated GetSubscriptionResponse into a Subscription', () async {
      final apiResponse = api.GetSubscriptionResponse(
        paused: false,
        active: true,
        expired: false,
        recurring: true,
        pauseAllowed: true,
        duration: api.GetSubscriptionResponseDuration(
          amount: 1,
          unit: api.GetSubscriptionResponseDurationUnitEnum.month,
        ),
        subscriptionId: 'sub-1',
        planId: 'plan_monthly',
        gateway: 'stripe',
      );
      when(apiSubscription.subscriptionStatus())
          .thenAnswer((_) async => response(200, apiResponse));

      final sub = await service.fetchSubscriptionDetails();

      expect(sub.active, isTrue);
      expect(sub.planId, 'plan_monthly');
      expect(sub.gateway, 'stripe');
      expect(sub.isPauseAllowed, isTrue);
      expect(sub.orderSummary, isNull);
    });

    test('copies orderSummary onto the subscription', () async {
      final apiResponse = api.GetSubscriptionResponse(
        paused: false,
        active: true,
        expired: false,
        recurring: true,
        pauseAllowed: true,
        duration: api.GetSubscriptionResponseDuration(
          amount: 1,
          unit: api.GetSubscriptionResponseDurationUnitEnum.month,
        ),
        subscriptionId: 'sub-1',
        orderSummary: api.GetSubscriptionResponseOrderSummary(
          country: 'US',
          currency: 'USD',
          itemSubtotal: '70.00',
          itemSubtotalBeforeDiscount: '80.00',
          taxRate: '0.1',
          taxSubtotal: '4.23',
          taxSubtotalBeforeDiscount: '9.54',
          taxType: 'vat',
          totalPrice: '74.23',
          totalPriceBeforeDiscount: '89.54',
          discountAmount: '15.31',
          discountUnits: 'usd',
        ),
      );
      when(apiSubscription.subscriptionStatus())
          .thenAnswer((_) async => response(200, apiResponse));

      final sub = await service.fetchSubscriptionDetails();

      expect(
        sub.orderSummary,
        OrderSummary(currency: 'USD', totalPrice: '74.23', totalPriceBeforeDiscount: '89.54'),
      );
    });

    // The widget tests build domain ExtraDuration values directly, so only these
    // cover the wire enum -> ExtraDurationUnit mapping.
    for (final (wire, expected) in [
      ('day', ExtraDurationUnit.day),
      ('week', ExtraDurationUnit.week),
      ('month', ExtraDurationUnit.month),
      ('year', ExtraDurationUnit.year),
    ]) {
      test('maps an extra duration in $wire onto ${expected.name}', () async {
        final apiResponse = api.GetSubscriptionResponse(
          paused: false,
          active: true,
          expired: false,
          recurring: true,
          pauseAllowed: true,
          duration: api.GetSubscriptionResponseDuration(
            amount: 1,
            unit: api.GetSubscriptionResponseDurationUnitEnum.month,
          ),
          subscriptionId: 'sub-1',
          extraDuration: api.SubscriptionConfigResponsePlansInnerExtraDuration(
            amount: 3,
            unit: api.SubscriptionConfigResponsePlansInnerExtraDurationUnitEnum.values.firstWhere(
              (u) => u.value == wire,
            ),
          ),
        );
        when(apiSubscription.subscriptionStatus())
            .thenAnswer((_) async => response(200, apiResponse));

        final sub = await service.fetchSubscriptionDetails();

        expect(sub.extraDuration, ExtraDuration(amount: 3, unit: expected));
        expect(sub.bonusDuration, isNotNull);
      });
    }

    test('leaves extraDuration null when the response carries no bonus', () async {
      final apiResponse = api.GetSubscriptionResponse(
        paused: false,
        active: true,
        expired: false,
        recurring: true,
        pauseAllowed: true,
        duration: api.GetSubscriptionResponseDuration(
          amount: 1,
          unit: api.GetSubscriptionResponseDurationUnitEnum.month,
        ),
        subscriptionId: 'sub-1',
      );
      when(apiSubscription.subscriptionStatus())
          .thenAnswer((_) async => response(200, apiResponse));

      final sub = await service.fetchSubscriptionDetails();

      expect(sub.extraDuration, isNull);
      expect(sub.bonusDuration, isNull);
    });

    test('rethrows arbitrary errors without reporting them', () async {
      when(apiSubscription.subscriptionStatus()).thenThrow(Exception('boom'));

      await expectLater(service.fetchSubscriptionDetails(), throwsA(isA<Exception>()));
      verifyNever(logger.handle(any, any));
    });
  });

  group('fetchSubscriptionPlan / fetchSubscriptionConfig', () {
    test('fetchSubscriptionPlan returns the response payload', () async {
      final plan = api.GetPlanResponse(id: 'pl', description: 'desc', metadata: api.PlanMetadata());
      when(apiSubscription.plan()).thenAnswer((_) async => response(200, plan));

      final result = await service.fetchSubscriptionPlan();

      expect(result, plan);
    });

    test('fetchSubscriptionConfig returns the response payload', () async {
      final config = api.SubscriptionConfigResponse(
        gateways: const [],
        plans: const [],
        countries: const [],
        stripePublishableKey: '',
        stripeReturnUrl: '',
      );
      when(apiSubscription.subscriptionConfig()).thenAnswer((_) async => response(200, config));

      expect(await service.fetchSubscriptionConfig(), config);
    });
  });

  group('fetchPauseDurations', () {
    test('returns durations as the API sent them', () async {
      when(apiSubscription.pauseDurations())
          .thenAnswer((_) async => response(200, <String>['1', '3', '6']));

      expect(await service.fetchPauseDurations(), ['1', '3', '6']);
    });

    test('rethrows arbitrary errors without reporting them', () async {
      when(apiSubscription.pauseDurations()).thenThrow(Exception('boom'));

      await expectLater(service.fetchPauseDurations(), throwsA(isA<Exception>()));
      verifyNever(logger.handle(any, any));
    });
  });

  group('getProductsDetails intro offers', () {
    late _RecordingRepository repo;

    setUp(() {
      repo = _RecordingRepository(
        api: vpnApi,
        inAppPurchase: inAppPurchase,
        logger: logger,
        secureStorage: MockSecureStorageService(),
      );
    });

    api.SubscriptionConfigResponsePlansInner plan(String id) =>
        api.SubscriptionConfigResponsePlansInner(
          id: id,
          appleProductId: id,
          interval: api.SubscriptionConfigResponsePlansInnerInterval(
            unit: api.SubscriptionConfigResponsePlansInnerIntervalUnitEnum.values.firstWhere(
              (u) => u.value == 'month',
            ),
            amount: 1,
          ),
          price: api.SubscriptionConfigResponsePlansInnerPrice(USD: 0),
          prices: const [],
          supportedGateways: const ['apple'],
          metadata: api.SubscriptionConfigResponsePlansInnerMetadata(),
        );

    api.SubscriptionConfigResponse configFor(List<String> ids) => api.SubscriptionConfigResponse(
      gateways: const [],
      plans: ids.map(plan).toList(),
      countries: const [],
      stripePublishableKey: '',
      stripeReturnUrl: '',
    );

    const monthly = SK2SubscriptionPeriod(value: 1, unit: SK2SubscriptionPeriodUnit.month);

    SK2SubscriptionOffer introOffer({double price = 5}) => SK2SubscriptionOffer(
      price: price,
      type: SK2SubscriptionOfferType.introductory,
      period: monthly,
      periodCount: 1,
      paymentMode: SK2SubscriptionOfferPaymentMode.payAsYouGo,
    );

    AppStoreProduct2Details appleProduct(
      String id, {
      required String groupId,
      List<SK2SubscriptionOffer> offers = const [],
      double price = 10,
    }) => AppStoreProduct2Details.fromSK2Product(
      SK2Product(
        id: id,
        displayName: id,
        description: id,
        price: price,
        displayPrice: '\$$price',
        type: SK2ProductType.autoRenewable,
        priceLocale: SK2PriceLocale(currencyCode: 'USD', currencySymbol: r'$'),
        subscription: SK2SubscriptionInfo(
          subscriptionGroupID: groupId,
          promotionalOffers: offers,
          subscriptionPeriod: monthly,
        ),
      ),
    );

    void stubStore(List<ProductDetails> products) {
      when(inAppPurchase.queryProductDetails(any)).thenAnswer(
        (_) async => ProductDetailsResponse(productDetails: products, notFoundIDs: const []),
      );
    }

    test('resolves eligibility once for every plan in the same subscription group', () async {
      stubStore([
        appleProduct('plan_monthly', groupId: 'grp_1', offers: [introOffer()]),
        appleProduct('plan_yearly', groupId: 'grp_1', offers: [introOffer()]),
        appleProduct('plan_yearly_basic', groupId: 'grp_1', offers: [introOffer()]),
      ]);

      await repo.getProductsDetails(
        configFor(['plan_monthly', 'plan_yearly', 'plan_yearly_basic']),
        null,
      );

      expect(repo.eligibilityCalls, hasLength(1));
    });

    test('resolves eligibility once per subscription group', () async {
      stubStore([
        appleProduct('plan_monthly', groupId: 'grp_1', offers: [introOffer()]),
        appleProduct('plan_yearly', groupId: 'grp_1', offers: [introOffer()]),
        appleProduct('plan_lifetime', groupId: 'grp_2', offers: [introOffer()]),
      ]);

      await repo.getProductsDetails(
        configFor(['plan_monthly', 'plan_yearly', 'plan_lifetime']),
        null,
      );

      expect(repo.eligibilityCalls, hasLength(2));
    });

    test('skips the lookup entirely when a plan has no promotional offers', () async {
      stubStore([appleProduct('plan_monthly', groupId: 'grp_1')]);

      final details = await repo.getProductsDetails(configFor(['plan_monthly']), null);

      expect(repo.eligibilityCalls, isEmpty);
      expect(details.single.hasIntroductoryPrice, isFalse);
    });

    test('surfaces the introductory offer and price when the user is eligible', () async {
      stubStore([
        appleProduct('plan_yearly_basic', groupId: 'grp_1', offers: [introOffer()]),
      ]);

      final details = await repo.getProductsDetails(configFor(['plan_yearly_basic']), null);

      expect(details.single.offers, hasLength(1));
      expect(details.single.introductoryPrice, 5);
      expect(details.single.hasIntroductoryPrice, isTrue);
    });

    test('hides the introductory offer and price when the user is not eligible', () async {
      repo.eligible = false;
      stubStore([
        appleProduct('plan_yearly_basic', groupId: 'grp_1', offers: [introOffer()]),
      ]);

      final details = await repo.getProductsDetails(configFor(['plan_yearly_basic']), null);

      expect(details.single.offers, isEmpty);
      expect(details.single.hasIntroductoryPrice, isFalse);
    });
  });

  group('isEligibleForIntroOffer', () {
    test('returns false off Apple platforms without touching StoreKit', () async {
      final repo = RestSubscriptionRepository(
        api: vpnApi,
        inAppPurchase: inAppPurchase,
        logger: logger,
        secureStorage: MockSecureStorageService(),
        isApplePlatform: () => false,
      );

      expect(await repo.isEligibleForIntroOffer('plan_yearly_basic'), isFalse);
      verifyNever(logger.warning(any));
    });

    test('reports a StoreKit failure as a warning, never as a handled crash', () async {
      final repo = RestSubscriptionRepository(
        api: vpnApi,
        inAppPurchase: inAppPurchase,
        logger: logger,
        secureStorage: MockSecureStorageService(),
        isApplePlatform: () => true,
      );

      expect(await repo.isEligibleForIntroOffer('plan_yearly_basic'), isFalse);
      verify(logger.warning(any)).called(1);
      verifyNever(logger.handle(any, any));
    });
  });
}

class _RecordingRepository extends RestSubscriptionRepository {
  _RecordingRepository({
    required super.api,
    required super.inAppPurchase,
    required super.logger,
    required super.secureStorage,
  });

  final List<String> eligibilityCalls = [];
  bool eligible = true;

  @override
  Future<bool> isEligibleForIntroOffer(String productId) async {
    eligibilityCalls.add(productId);
    return eligible;
  }
}
