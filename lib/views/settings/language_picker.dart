import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:styled_widget/styled_widget.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    required this.store,
    super.key,
  });
  final LocaleStore store;
  @override
  Widget build(BuildContext context) => DropdownButton<Locale>(
        isExpanded: true,
        value: context.locale,
        icon: const Icon(Icons.arrow_drop_down),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        underline: const SizedBox.shrink(),
        onChanged: (Locale? newLocale) async {
          if (newLocale == null) {
            return;
          }
          await context.setLocale(newLocale);
          await store.setLocale(newLocale);
          return;
        },
        items: supportedLocales
            .map<DropdownMenuItem<Locale>>(
              (locale) => DropdownMenuItem<Locale>(
                value: locale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: EasyText(locale.languageName),
                ),
              ),
            )
            .toList(),
      ).padding(horizontal: 10).decorated(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          );
}
