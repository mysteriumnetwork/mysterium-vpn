import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/settings_picker_card.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(localeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    return Observer(
      builder: (_) => SettingsPickerCard<Locale>(
        title: LocaleKeys.languageSettingLbl.tr(),
        position: position,
        value: store.currentLocale,
        items: kSupportedLocales,
        labelOf: (locale) => locale.languageCode.tr(),
        onChanged: (locale) async {
          await context.setLocale(locale);
          await store.setLocale(locale);
          analyticsStore.logLanguageChange(locale.languageCode);
        },
      ),
    );
  }
}
