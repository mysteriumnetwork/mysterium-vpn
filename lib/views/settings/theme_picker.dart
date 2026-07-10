import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
        key: K.themePickerCard,
        sheetKey: K.themePickerSheet,
        itemKeyOf: (mode) => switch (mode) {
          ThemeMode.light => K.themeOptionLight,
          ThemeMode.dark => K.themeOptionDark,
          ThemeMode.system => K.themeOptionSystem,
        },
        title: S.current.appearanceSettingLbl,
        position: position,
        value: store.themeMode,
        items: ThemeMode.values,
        labelOf: (mode) => switch (mode) {
          ThemeMode.light => S.current.light,
          ThemeMode.dark => S.current.dark,
          ThemeMode.system => S.current.system,
        },
        onChanged: (mode) {
          store.setThemeType(mode);
          analyticsStore.logThemeChange(mode.name);
        },
      ),
    );
  }
}
