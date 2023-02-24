import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({
    required this.store,
    super.key,
  });
  final ThemeStore store;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => EasyDropdown<ThemeMode>(
          value: store.themeMode,
          onChanged: (ThemeMode? newThemeMode) {
            if (newThemeMode == null) {
              return;
            }
            store.setThemeType(newThemeMode);
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
