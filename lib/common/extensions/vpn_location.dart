import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/location.dart';

extension VPNLocationExtensions on VPNLocation {
  String get name => getName();

  String getName([BuildContext? context]) {
    Locale locale;
    try {
      context ??= rootContext;
      locale = EasyLocalization.of(context)!.locale;
    } catch (e) {
      locale = kFallbackLocale;
    }

    if (translations.isNotEmpty) {
      var value = translations[locale.languageCode.toLowerCase()];
      if (value == null && locale.countryCode != null) {
        value = translations[locale.countryCode!.toLowerCase()];
      }
      return value ?? translations['en'] ?? translations.values.firstOrNull ?? id;
    }
    return id;
  }
}
