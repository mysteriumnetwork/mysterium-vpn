import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/shared/components/easy_dropdown.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({required this.store, required this.analyticsStore, super.key});
  final ThemeStore store;
  final AnalyticsStore analyticsStore;
  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) => EasyDropdown<ThemeMode>(
      value: store.themeMode,
      onChanged: (ThemeMode? newThemeMode) {
        if (newThemeMode == null) {
          return;
        }
        store.setThemeType(newThemeMode);
        analyticsStore.logThemeChange(newThemeMode.name);
        return;
      },
      items: ThemeMode.values
          .map<DropdownMenuItem<ThemeMode>>(
            (themeMode) => DropdownMenuItem<ThemeMode>(
              value: themeMode,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: EasyText(themeMode.name.tr()),
              ),
            ),
          )
          .toList(),
    ),
  );
}
