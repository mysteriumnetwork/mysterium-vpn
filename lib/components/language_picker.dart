import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeStore = ref.watch(localeStorePOD);

    return Observer(builder: (context) {
      return DropdownButton<Locale>(
          isDense: true,
          value: localeStore.currentLocale,
          icon: const Icon(Icons.arrow_drop_down),
          underline: Container(
            height: 1,
            color: Colors.black26,
          ),
          onChanged: (Locale? newLocale) {
            if (newLocale == null) {
              return;
            }
            localeStore.setLocale(newLocale);
            return;
          },
          items: localeStore.supportedLocales
              .map<DropdownMenuItem<Locale>>(
                (locale) => DropdownMenuItem<Locale>(
                  value: locale,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(locale.languageName),
                  ),
                ),
              )
              .toList());
    });
  }
}
