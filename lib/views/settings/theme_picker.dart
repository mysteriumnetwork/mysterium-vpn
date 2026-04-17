import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/settings_picker_card.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ThemePicker extends ConsumerWidget {
  const ThemePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(themeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

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
