import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Preferences: change the app language', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await login($, const String.fromEnvironment('LOGIN_EMAIL'));

    await openSettingsCategory($, #settingsPreferencesCategory);

    // Switching the locale rebuilds the entire app (MaterialApp.locale changes
    // and `S` reloads). Switch to Spanish, then back to English — keys are
    // language-independent, so this leaves the app in a known state.
    await selectFromPicker($, #languagePickerCard, #languagePickerSheet, #languageOption_es);
    await selectFromPicker($, #languagePickerCard, #languagePickerSheet, #languageOption_en);
  });
}
