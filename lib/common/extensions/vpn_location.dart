import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/models/models.dart';

extension VPNLocationExtensions on VPNLocation {
  String _getName(BuildContext context) {
    // Register a Localizations dependency so build-context callers rebuild on a
    // locale switch. Guarded: this also runs inside a Computed's initHook, where
    // inherited-widget lookups assert — there, rebuilds come from the
    // locale-keyed Computed / page remount instead.
    try {
      Localizations.maybeLocaleOf(context);
    } catch (_) {
      // In a hook's initHook — nothing to depend on here.
    }
    // Resolve the value from `activeLocale`, not Localizations: the latter
    // lags / differs per context on a switch, which showed stale (mixed
    // old/new) location names.
    final locale = activeLocale;

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

/// Country/city display names for a location and its optional parent: with a
/// parent, the parent names the country and the location the city; without
/// one, the location itself is the country.
({String country, String city}) locationDisplayNames(
  BuildContext context, {
  required VPNLocation? location,
  required VPNLocation? parent,
}) => (
  country: parent?.getName(context) ?? location?.getName(context) ?? '',
  city: parent != null ? location?.getName(context) ?? '' : '',
);
