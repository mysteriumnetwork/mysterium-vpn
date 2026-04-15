import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/shared/components/easy_dropdown.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({required this.store, required this.analyticsStore, super.key});
  final LocaleStore store;
  final AnalyticsStore analyticsStore;
  @override
  Widget build(BuildContext context) => EasyDropdown<Locale>(
    value: store.currentLocale,
    onChanged: (Locale? newLocale) async {
      if (newLocale == null) {
        return;
      }
      await context.setLocale(newLocale);
      await store.setLocale(newLocale);
      analyticsStore.logLanguageChange(newLocale.languageCode);
      return;
    },
    items: kSupportedLocales
        .map<DropdownMenuItem<Locale>>(
          (locale) => DropdownMenuItem<Locale>(
            value: locale,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: EasyText(locale.languageCode.tr()),
            ),
          ),
        )
        .toList(),
  );
}
