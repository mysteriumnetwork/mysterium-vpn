import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    required this.store,
    super.key,
  });
  final LocaleStore store;
  @override
  Widget build(BuildContext context) => EasyDropdown<Locale>(
        value: store.currentLocale,
        onChanged: (Locale? newLocale) async {
          if (newLocale == null) {
            return;
          }
          await context.setLocale(newLocale);
          await store.setLocale(newLocale);
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
