import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:styled_widget/styled_widget.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key, required this.store}) : super(key: key);
  final ThemeStore store;
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return DropdownButton<ThemeMode>(
        isExpanded: true,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        value: store.themeMode,
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox.shrink(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: EasyText(themeMode.name.tr()),
                  )),
            )
            .toList(),
      ).padding(horizontal: 10).decorated(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          );
    });
  }
}
