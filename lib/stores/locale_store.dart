import 'dart:ui' as ui;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

// Include generated file
part 'locale_store.g.dart';

// ignore: library_private_types_in_public_api
class LocaleStore = _LocaleStore with _$LocaleStore;

abstract class _LocaleStore with Store {
  _LocaleStore() {
    currentLocale = SharedPreferenceService.getLocale() ?? const ui.Locale('en', 'US');

    loco = lookupAppLocalizations(currentLocale);
  }

  @observable
  AppLocalizations loco = lookupAppLocalizations(const ui.Locale('en', 'US'));

  @observable
  late ui.Locale currentLocale = const ui.Locale('en', 'US');

  final List<ui.Locale> supportedLocales = [
    const ui.Locale('en', 'US'),
    const ui.Locale('es', 'ES'),
  ];

  @action
  Future<void> setLocale(ui.Locale locale) async {
    // Set the locale if it's in our list of supported locales
    if (supportedLocales.contains(locale)) {
      await SharedPreferenceService.setLocale(locale);
      currentLocale = locale;
      loco = lookupAppLocalizations(locale);
      return;
    }
  }
}
