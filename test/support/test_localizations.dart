import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Localization wiring for widget tests, replacing the old easy_localization
/// test harness. `S` is preloaded globally by `flutter_test_config.dart`.
const Locale testLocale = Locale('en');

const List<LocalizationsDelegate<dynamic>> testLocalizationsDelegates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

List<Locale> get testSupportedLocales => S.delegate.supportedLocales;
