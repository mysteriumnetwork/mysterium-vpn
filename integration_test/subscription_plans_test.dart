import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Subscription: the upgrade page shows a plan card', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await login($, const String.fromEnvironment('LOGIN_EMAIL'));

    await openSubscriptionPage($);

    // Plans load from the backend, so wait for the highlighted plan card.
    await $(#subscriptionPlanCard).waitUntilVisible(timeout: const Duration(seconds: 20));
    expect($(#subscriptionPlanCard), findsOneWidget);
  });
}
