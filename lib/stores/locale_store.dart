import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/services/services.dart';

// Include generated file
part 'locale_store.g.dart';

// ignore: library_private_types_in_public_api
class LocaleStore = _LocaleStore with _$LocaleStore;

abstract class _LocaleStore with Store {
  _LocaleStore({required SharedPreferenceService sharedPrefs}) : _sharedPrefs = sharedPrefs {
    _currentLocale = _sharedPrefs.getLocale();
  }

  final SharedPreferenceService _sharedPrefs;
  @readonly
  Locale _currentLocale = kFallbackLocale;

  @action
  Future<void> setLocale(Locale locale) async {
    // Set the locale if it's one we support.
    if (supportedLocales.contains(locale)) {
      await _sharedPrefs.setLocale(locale);
      _currentLocale = locale;
    }
  }
}
