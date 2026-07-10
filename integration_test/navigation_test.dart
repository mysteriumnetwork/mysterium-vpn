import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Navigation: each bottom-nav tab opens its screen', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await login($, const String.fromEnvironment('LOGIN_EMAIL'));

    // Map is the landing tab — its connection status bar is showing.
    await $(#connectionStatusBar).waitUntilVisible();

    await $(#locationsTab).tap();
    await $(#locationSearch).waitUntilVisible();

    await $(#productsTab).tap();
    await $(#productsView).waitUntilVisible();

    await $(#settingsTab).tap();
    await $(#settingsAccountCategory).waitUntilVisible();

    // Back to the map tab.
    await $(#mapTab).tap();
    await $(#connectionStatusBar).waitUntilVisible();
  });
}
