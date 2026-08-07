import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/subscription/rest_subscription_service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart' as api;

import 'rest_subscription_service_test.mocks.dart';

@GenerateNiceMocks([
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
  late RestSubscriptionService service;

  setUp(() {
    vpnApi = MockVpnApi();
    apiSubscription = MockSubscription();
    inAppPurchase = MockInAppPurchase();
    logger = MockTalker();

    when(vpnApi.getSubscription()).thenReturn(apiSubscription);

    service = RestSubscriptionService(api: vpnApi, inAppPurchase: inAppPurchase, logger: logger);
  });

  Response<T> response<T>(int code, T data) =>
      Response<T>(requestOptions: RequestOptions(), statusCode: code, data: data);

  group('fetchSubscriptionDetails', () {
    test('maps a populated GetSubscriptionResponse into a Subscription', () async {
      final apiResponse = api.GetSubscriptionResponse(
        paused: false,
        active: true,
        expired: false,
        recurring: true,
        subscriptionId: 'sub-1',
        planId: 'plan_monthly',
        gateway: 'stripe',
        paused: false,
      );
      when(
        apiSubscription.subscriptionStatus(),
      ).thenAnswer((_) async => response(200, apiResponse));

      final sub = await service.fetchSubscriptionDetails();

      expect(sub.active, isTrue);
      expect(sub.planId, 'plan_monthly');
      expect(sub.gateway, 'stripe');
    });

    test('rethrows arbitrary errors after logging', () async {
      when(apiSubscription.subscriptionStatus()).thenThrow(Exception('boom'));

      await expectLater(service.fetchSubscriptionDetails(), throwsA(isA<Exception>()));
      verify(logger.handle(any, any)).called(1);
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
}
