import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/banners/promotional_banner.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends HookConsumerWidget {
  const SettingsDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentPanelHeader(category: settingCategory),
            const PromoBanner(),
            const AppVersionUpdateSetting(),
            switch (settingCategory) {
              SettingCategory.account => const AccountSettings(),
              SettingCategory.connection => const ConnectionSettings(),
              SettingCategory.preferences => const ApplicationSettings(),
              SettingCategory.qaToolbox => const QAToolbox(),
            },
          ],
        )
        .scrollable()
        .backgroundColor(theme.palette.bgPrimary)
        .height(getMediaHeight(context))
        .width(getMediaWidth(context) - 360);
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
