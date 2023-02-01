import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localStore = ref.watch(localeStorePOD);
    return Observer(builder: (context) {
      return DropdownButton<Locale>(
          isDense: true,
          value: context.locale,
          icon: const Icon(Icons.arrow_drop_down),
          underline: Container(
            height: 1,
            color: Colors.black26,
          ),
          onChanged: (Locale? newLocale) async {
            if (newLocale == null) {
              return;
            }
            await context.setLocale(newLocale);
            localStore.setLocale(newLocale);
            return;
          },
          items: supportedLocales
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
