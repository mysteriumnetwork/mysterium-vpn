import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/settings/views/account_settings.dart';
import 'package:mysterium_vpn/features/settings/views/application_settings.dart';
import 'package:mysterium_vpn/features/settings/views/connection_settings.dart';
import 'package:mysterium_vpn/features/settings/views/qa_toolbox.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_view.dart';
import 'package:mysterium_vpn/features/settings/views/version_update_setting.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/shared/components/banners/promotional_banner.dart';
import 'package:mysterium_vpn/shared/components/circle_box.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends StatelessWidget {
  const SettingsDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final settingCategory = readSelectedCategory(context);
    return Column(
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 12),
              child: _HeaderTitle(title: settingCategory.trKey.tr()),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 18), child: PromoBanner()),
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
  const _HeaderTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      EasyText(LocaleKeys.settings.tr(), fontSize: 20, fontWeight: FontWeight.w700),
      CircleBox(size: 8, color: Theme.of(context).secondaryHeaderColor).padding(horizontal: 14),
      EasyText(title, fontSize: 20, fontWeight: FontWeight.w300, color: Palette.purple),
    ],
  );
}
