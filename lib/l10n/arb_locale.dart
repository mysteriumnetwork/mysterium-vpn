import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Single source of truth for the locales the app supports — the set `S` was
/// generated for. Drives the language picker, locale persistence, and loading.
List<Locale> get supportedLocales => S.delegate.supportedLocales;

/// Resolves a (possibly country-coded) app locale to the locale `S` should load:
/// keeps the country code only when a dedicated ARB exists (e.g. pt-BR), else
/// falls back to the languageCode.
Locale arbLocaleFor(Locale locale) {
  if (locale.countryCode == null) {
    return locale;
  }
  final full = Locale(locale.languageCode, locale.countryCode);
  return supportedLocales.contains(full) ? full : Locale(locale.languageCode);
}

Locale? _loadedArbLocale;

/// Bumped after an over-the-air translation update so the widget tree rebuilds
/// and re-reads `S.current` — `S.load` alone doesn't notify Flutter.
final localizationRevision = ValueNotifier<int>(0);

/// Loads `S` for [locale] (resolved via [arbLocaleFor]), skipping when that ARB
/// locale is already active. Pass [force] after an OTA update to reload the same
/// locale with refreshed translations.
Future<void> loadLocalizations(Locale locale, {bool force = false}) async {
  final target = arbLocaleFor(locale);
  if (!force && target == _loadedArbLocale) {
    return;
  }
  _loadedArbLocale = target;
  await S.load(target);
}
