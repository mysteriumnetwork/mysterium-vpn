import 'dart:ui' as ui;

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

// Include generated file
part 'locale_store.g.dart';

// ignore: library_private_types_in_public_api
class LocaleStore = _LocaleStore with _$LocaleStore;

abstract class _LocaleStore with Store {
  _LocaleStore() {
    _currentLocale = SharedPreferenceService.getLocale() ?? const ui.Locale('en');
  }

  @readonly
  ui.Locale _currentLocale = const ui.Locale('en');

  @action
  Future<void> setLocale(ui.Locale locale) async {
    // Set the locale if it's in our list of supported locales
    if (supportedLocales.contains(locale)) {
      await SharedPreferenceService.setLocale(locale);
      _currentLocale = locale;
    }
  }
}
