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
    await pumpApp($, environment);
    await loginWithEnv($);

    await openSettingsCategory($, #settingsPreferencesCategory);

    // Switch to Spanish, then back to English. The locale change bumps
    // `localizationRevision`, which now only remounts the page subtree (below
    // the Beamer Router) — so it no longer triggers the Router's restoration /
    // "setState during build" assertion that used to flake here.
    await selectFromPicker($, #languagePickerCard, #languagePickerSheet, #languageOption_es);
    await selectFromPicker($, #languagePickerCard, #languagePickerSheet, #languageOption_en);
  });
}
