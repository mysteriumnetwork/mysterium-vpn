import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/settings/views/settings_picker_card.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final store = getIt<ThemeStore>();
    final analyticsStore = getIt<AnalyticsStore>();

    return Observer(
      builder: (_) => SettingsPickerCard<ThemeMode>(
        title: LocaleKeys.appearanceSettingLbl.tr(),
        position: position,
        value: store.themeMode,
        items: ThemeMode.values,
        labelOf: (mode) => mode.name.tr(),
        onChanged: (mode) {
          store.setThemeType(mode);
          analyticsStore.logThemeChange(mode.name);
        },
      ),
    );
  }
}
