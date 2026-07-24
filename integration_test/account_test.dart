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

  patrolTest('Account: the settings account screen shows the signed-in email', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    const email = String.fromEnvironment('LOGIN_EMAIL');
    await login($, email);

    await openSettingsCategory($, #settingsAccountCategory);

    // The account card title is the signed-in user's email, populated
    // asynchronously after login.
    await $(email).waitUntilVisible();
    expect($(email), findsWidgets);
  });
}
