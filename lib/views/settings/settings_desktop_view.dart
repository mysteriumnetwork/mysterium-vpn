import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_left_panel.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_right_panel.dart';

const _initialCategory = SettingCategory.connection;

final selectedCategoryProvider = StateProvider<SettingCategory>((ref) => _initialCategory);

enum SettingCategory {
  connection(LocaleKeys.connection),
  account(LocaleKeys.account),
  preferences(LocaleKeys.preferences),
  qaToolbox('QA Toolbox');

  const SettingCategory(this.trKey);
  final String trKey;
}

class SettingsDesktopView extends HookWidget {
  const SettingsDesktopView({super.key});

  @override
  Widget build(BuildContext context) => const DesktopPanelsLayout(
        leftPanel: SettingsDesktopLeftPanel(),
        rightPanel: SettingsDesktopRightPanel(),
      );
}
