import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/settings/views/setting_category.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_left_panel.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_right_panel.dart';
import 'package:styled_widget/styled_widget.dart';

const _initialCategory = SettingCategory.account;

class _SettingCategoryScope extends InheritedWidget {
  const _SettingCategoryScope({
    required this.category,
    required this.onCategoryChanged,
    required super.child,
  });

  final SettingCategory category;
  final ValueChanged<SettingCategory> onCategoryChanged;

  static _SettingCategoryScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SettingCategoryScope>()!;

  @override
  bool updateShouldNotify(_SettingCategoryScope old) => category != old.category;
}

class SettingsDesktopView extends StatefulWidget {
  const SettingsDesktopView({super.key});

  @override
  State<SettingsDesktopView> createState() => _SettingsDesktopViewState();
}

class _SettingsDesktopViewState extends State<SettingsDesktopView> {
  SettingCategory _category = _initialCategory;

  @override
  Widget build(BuildContext context) => _SettingCategoryScope(
    category: _category,
    onCategoryChanged: (cat) => setState(() => _category = cat),
    child: const Row(
      children: [SettingsDesktopLeftPanel(), SettingsDesktopRightPanel()],
    ).width(getMediaWidth(context)).height(getMediaHeight(context)),
  );
}

/// Reads current selected category from the scope.
SettingCategory readSelectedCategory(BuildContext context) =>
    _SettingCategoryScope.of(context).category;

/// Updates the selected category in the scope.
void updateSelectedCategory(BuildContext context, SettingCategory category) =>
    _SettingCategoryScope.of(context).onCategoryChanged(category);
