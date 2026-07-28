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

  patrolTest('Locations: the locations tab opens with its search field', ($) async {
    await pumpApp($, environment);
    await loginWithEnv($);

    await $(#locationsTab).waitUntilVisible();
    await $(#locationsTab).tap();

    // The locations screen is up once its search field renders.
    await $(#locationSearch).waitUntilVisible();
    expect($(#locationSearch), findsOneWidget);
  });
}
