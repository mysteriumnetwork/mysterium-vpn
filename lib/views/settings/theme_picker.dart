import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/picker_bottom_sheet.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

class ThemePicker extends ConsumerWidget {
  const ThemePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(themeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final title = LocaleKeys.appearanceSettingLbl.tr();

    void onChange(ThemeMode mode) {
      store.setThemeType(mode);
      analyticsStore.logThemeChange(mode.name);
    }

    if (isDesktop) {
      return SettingsCard(
        title: title,
        position: position,
        trailing: Observer(
          builder: (_) => EasyDropdown<ThemeMode>(
            value: store.themeMode,
            onChanged: (ThemeMode? mode) {
              if (mode == null) {
                return;
              }
              onChange(mode);
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
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showPickerBottomSheet<ThemeMode>(
        context: context,
        title: title,
        items: ThemeMode.values,
        value: store.themeMode,
        labelOf: (mode) => mode.name.tr(),
        onChanged: onChange,
      ),
      child: SettingsCard(
        title: title,
        position: position,
        trailing: Icon(UntitledUI.chevron_right, size: 24, color: theme.palette.iconTertiary),
      ),
    );
  }
}
