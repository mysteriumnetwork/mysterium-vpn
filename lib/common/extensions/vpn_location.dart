import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/models/models.dart';

extension VPNLocationExtensions on VPNLocation {
  String _getName(BuildContext context) {
    Locale locale;
    try {
      locale = Localizations.localeOf(context);
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
    // No server-provided translations (e.g. recent locations built from a
    // country code) — translate the code at display time, falling back to the
    // raw code when there's no matching key.
    return Tr.byKeyOrNull(id) ?? id;
  }

  String getName(BuildContext context) => _getName(context).capitalizeWords();

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

  String get shortString => '${{id, countryCode}.join('-')} ($nodeCount)';
}
