import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_left_panel.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_right_panel.dart';
import 'package:styled_widget/styled_widget.dart';

const _initialCategory = SettingCategory.account;

class SelectedCategoryNotifier extends Notifier<SettingCategory> {
  @override
  SettingCategory build() => _initialCategory;
  SettingCategory get category => state;
  set category(SettingCategory value) => state = value;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, SettingCategory>(
  SelectedCategoryNotifier.new,
);

class SettingsDesktopView extends HookWidget {
  const SettingsDesktopView({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    children: [SettingsDesktopLeftPanel(), SettingsDesktopRightPanel()],
  ).width(getMediaWidth(context)).height(getMediaHeight(context));
}
