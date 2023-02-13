import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:styled_widget/styled_widget.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key, required this.store}) : super(key: key);
  final ThemeStore store;
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return DropdownButton<ThemeType>(
        isExpanded: true,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        value: store.themeType,
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox.shrink(),
        onChanged: (ThemeType? newThemeType) {
          if (newThemeType == null) {
            return;
          }
          store.setThemeType(newThemeType);
          return;
        },
        items: ThemeType.values
            .map<DropdownMenuItem<ThemeType>>(
              (themeType) => DropdownMenuItem<ThemeType>(
                  value: themeType,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: EasyText(themeType.label),
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
