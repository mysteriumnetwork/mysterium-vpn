import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Preferences: change the app theme', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await loginWithEnv($);

    await openSettingsCategory($, #settingsPreferencesCategory);
    await selectFromPicker($, #themePickerCard, #themePickerSheet, #themeOption_dark);
  });
}
