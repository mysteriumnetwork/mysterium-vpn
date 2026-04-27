import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/settings/views/setting_category.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_view.dart';
import 'package:mysterium_vpn/features/settings/views/version_update_setting.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends StatelessWidget {
  const SettingsDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final settingCategory = readSelectedCategory(context);
    final theme = Theme.of(context);

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentPanelHeader(category: settingCategory),
            const PromoBanner(),
            const AppVersionUpdateSetting(),
            settingCategory.content,
          ],
        )
        .scrollable()
        .backgroundColor(theme.palette.bgPrimary)
        .height(getMediaHeight(context))
        .width(getMediaWidth(context) - 346);
  }
}

class _ContentPanelHeader extends StatelessWidget {
  const _ContentPanelHeader({required this.category});

  final SettingCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      category.trKey.tr(),
      style: theme.textStyles.textLg.semibold.copyWith(color: theme.palette.textTertiary),
    ).padding(horizontal: theme.spacing.xl3, vertical: theme.spacing.xl2);
  }
}
