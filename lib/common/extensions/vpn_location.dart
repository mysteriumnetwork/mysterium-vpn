import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/location.dart';

extension VPNLocationExtensions on VPNLocation {
  String _getName(BuildContext context) {
    Locale locale;
    try {
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

  String getName(BuildContext context) => _getName(context).capitalizeWords();

  bool get isCountry => id == countryCode;

  VPNLocation? queried(String query, String locale) {
    if (query.isEmpty) {
      return this;
    }

    final code = id.trim().toLowerCase();
    final name = translations[locale]?.trim().toLowerCase();
    if ((name?.contains(query) ?? false) || code.contains(query)) {
      return this;
    }

    if (children != null) {
      final children = this.children!.map((it) => it.queried(query, locale)).nonNulls.toList();
      if (children.isNotEmpty) {
        return copyWith(children: children);
      }
    }

    return null;
  }
}
