import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

import 'subscription_config_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<SubscriptionService>(),
  MockSpec<SubscriptionConfigResponse>(),
  MockSpec<GetPlanResponse>(),
])
void main() {
  late MockAuthSessionStore session;
  late MockSubscriptionService service;

  late MockSubscriptionConfigResponse config;
  late MockGetPlanResponse plan;

  setUp(() {
    session = MockAuthSessionStore();
    service = MockSubscriptionService();
    config = MockSubscriptionConfigResponse();
    plan = MockGetPlanResponse();

    when(plan.id).thenReturn('plan_monthly');
    when(session.accessToken).thenReturn(null);
    when(service.fetchSubscriptionConfig()).thenAnswer((_) async => config);
    when(service.clearPendingTransactions()).thenAnswer((_) async {});
    when(service.fetchSubscriptionPlan()).thenAnswer((_) async => plan);
  });

  SubscriptionConfigStore newStore() => SubscriptionConfigStore(session, service);

  test('refreshConfig fetches and exposes the config', () async {
    final store = newStore();

    final result = await store.refreshConfig();

    expect(result, config);
    expect(store.future.value, config);
    verify(service.fetchSubscriptionConfig()).called(1);
  });

  test('refreshPlan exposes a non-null plan future', () async {
    final store = newStore()..refreshPlan();

    final result = await store.subscriptionPlanFuture;

    expect(result.id, 'plan_monthly');
  });

  test('clearPendingTransactions errors are swallowed', () async {
    when(
      service.clearPendingTransactions(),
    ).thenAnswer((_) => Future.error(Exception('platform fail')));

    final store = newStore();
    await expectLater(store.refreshConfig(), completes);
  });

  test('reaction to accessToken triggers a fetch', () async {
    when(session.accessToken).thenReturn('token-1');
    final store = newStore();

    // Wait for the reaction-driven fetch to resolve.
    await Future<void>.delayed(Duration.zero);
    await store.future;

    verify(service.fetchSubscriptionConfig()).called(greaterThanOrEqualTo(1));
  });

  test('dispose disposes reactions without error', () async {
    final store = newStore();
    await store.dispose();
  });
}
