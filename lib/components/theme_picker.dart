import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

class ThemePicker extends ConsumerWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);

    return Observer(builder: (context) {
      return DropdownButton<ThemeType>(
          isDense: true,
          value: themeStore.themeType,
          icon: const Icon(Icons.arrow_drop_down),
          underline: Container(
            height: 1,
            color: Colors.black26,
          ),
          onChanged: (ThemeType? newThemeType) {
            if (newThemeType == null) {
              return;
            }
            themeStore.setThemeType(newThemeType);
            return;
          },
          items: ThemeType.values
              .map<DropdownMenuItem<ThemeType>>(
                (themeType) => DropdownMenuItem<ThemeType>(
                  value: themeType,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(themeType.label),
                  ),
                ),
              )
              .toList());
    });
  }
}
