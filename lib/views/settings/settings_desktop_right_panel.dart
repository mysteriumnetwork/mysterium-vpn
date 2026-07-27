import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Mirrors the constant in `settings_desktop_left_panel.dart` — the desktop
/// view always has a category selected, while mobile starts on the main list
/// (sub-page = null). Falling back here keeps the right panel populated on
/// first load.
const _defaultDesktopCategory = SettingCategory.account;

class SettingsDesktopRightPanel extends HookConsumerWidget {
  const SettingsDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsStore = ref.watch(homeTabsStorePOD);
    final settingCategory = useComputedValue(
      () => tabsStore.settingsSubPage ?? _defaultDesktopCategory,
    );
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.palette.bgPrimary,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentPanelHeader(category: settingCategory),
            const PromoBanner(),
            const AppVersionUpdateSetting(),
            settingCategory.content,
          ],
        ),
      ),
    );
  }
}

class _ContentPanelHeader extends StatelessWidget {
  const _ContentPanelHeader({required this.category});

  final SettingCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3, vertical: theme.spacing.xl2),
      child: Text(
        category.label,
        style: theme.textStyles.textLg.semibold.copyWith(color: theme.palette.textTertiary),
      ),
    );
  }
}
