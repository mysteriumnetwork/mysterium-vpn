import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Login validation: an invalid email keeps the user on the login screen', ($) async {
    await pumpApp($, environment);

    await $(#loginPage).waitUntilVisible();
    await $(#loginEmailField).enterText('not-an-email');
    await $(#loginButton).tap();

    // Invalid input fails client-side validation, so the app must not navigate
    // away from the login screen.
    await $.pumpAndSettle();
    expect($(#loginPage), findsOneWidget);
    expect($(#homePage), findsNothing);
  });
}
