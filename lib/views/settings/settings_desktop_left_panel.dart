import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/desktop_page_header.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/category_item.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopLeftPanel extends StatelessWidget {
  const SettingsDesktopLeftPanel({
    required this.settingCategory,
    super.key,
  });
  final ValueNotifier<SettingCategory> settingCategory;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesktopPageHeader(
            onPressed: () {
              context.beamToReplacementNamed(Routes.reportIssue.toRoute);
            },
            asset: Assets.reportPurple,
          ).padding(bottom: 40),
          ListView(
            shrinkWrap: true,
            children: [
              Visibility(
                visible: false,
                child: CategoryItem(
                  isSelected: settingCategory.value == SettingCategory.connection,
                  title: SettingCategory.connection.trKey.tr(),
                  onTap: () => settingCategory.value = SettingCategory.connection,
                ),
              ),
              CategoryItem(
                isSelected: settingCategory.value == SettingCategory.application,
                title: SettingCategory.application.trKey.tr(),
                onTap: () => settingCategory.value = SettingCategory.application,
              ),
              CategoryItem(
                isSelected: settingCategory.value == SettingCategory.account,
                title: SettingCategory.account.trKey.tr(),
                onTap: () => settingCategory.value = SettingCategory.account,
              ),
            ],
          ).expanded(),
          AppVersion(
            headerText: LocaleKeys.appVersion.tr(),
          ),
        ],
      ).padding(horizontal: 40, vertical: 40);
}
