import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/banners/subscription_upgrade_banner.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends HookConsumerWidget {
  const SettingsDesktopRightPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingCategory = ref.watch(selectedCategoryProvider);
    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 12),
          child: _HeaderTitle(title: settingCategory.trKey.tr()),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 18),
          child: SubscriptionUpgradeBanner(),
        ),
        const AppVersionUpdateSetting(),
        switch (settingCategory) {
          SettingCategory.connection => const ConnectionSettings(),
          SettingCategory.preferences => const ApplicationSettings(),
          SettingCategory.account => const AccountSettings(),
          SettingCategory.qaToolbox => const QAToolbox(),
        },
      ],
    )
        .scrollable()
        .height(getMediaHeight(context))
        .backgroundColor(context.c.isDarkMode ? Palette.darkBlue : Palette.white);
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          EasyText(
            LocaleKeys.settings.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          CircleBox(
            size: 8,
            color: Theme.of(context).secondaryHeaderColor,
          ).padding(horizontal: 14),
          EasyText(
            title,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Palette.purple,
          ),
        ],
      );
}
