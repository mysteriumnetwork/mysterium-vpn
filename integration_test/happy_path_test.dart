import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Happy path: log in, then open the subscription page', ($) async {
    await pumpApp($, environment);
    await loginWithEnv($);
    await openSubscriptionPage($);
  });
}
