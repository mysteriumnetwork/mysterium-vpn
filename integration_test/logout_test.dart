import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Logout: from Settings > Account returns to the login screen', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await login($, const String.fromEnvironment('LOGIN_EMAIL'));
    await logout($);
  });
}
