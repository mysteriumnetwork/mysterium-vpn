import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/settings/views/settings_picker_card.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final store = getIt<LocaleStore>();
    final analyticsStore = getIt<AnalyticsStore>();

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
