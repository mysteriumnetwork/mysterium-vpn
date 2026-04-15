import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/category_item.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_view.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/api_version.dart';
import 'package:mysterium_vpn/shared/components/app_version.dart';
import 'package:mysterium_vpn/shared/components/desktop_page_header.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopLeftPanel extends StatelessWidget {
  const SettingsDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = getIt<RemoteConfigStore>();
    return Observer(
      builder: (context) {
        final settingCategory = readSelectedCategory(context);
        final enableQaHelpers = remoteConfig.enableQaHelpers;
        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesktopPageHeader(
                  onPressed: () => handleOnSupportPage(
                    context: context,
                    analyticsStore: getIt<AnalyticsStore>(),
                  ),
                  asset: Asset.icons.reportAdaptive(context),
                ).padding(bottom: 10),
                ListView(
                  shrinkWrap: true,
                  children: [
                    CategoryItem(
                      isSelected: settingCategory == SettingCategory.connection,
                      title: SettingCategory.connection.trKey.tr(),
                      onTap: () => updateSelectedCategory(context, SettingCategory.connection),
                    ),
                    CategoryItem(
                      isSelected: settingCategory == SettingCategory.preferences,
                      title: SettingCategory.preferences.trKey.tr(),
                      onTap: () => updateSelectedCategory(context, SettingCategory.preferences),
                    ),
                    CategoryItem(
                      isSelected: settingCategory == SettingCategory.account,
                      title: SettingCategory.account.trKey.tr(),
                      onTap: () => updateSelectedCategory(context, SettingCategory.account),
                    ),
                    if (enableQaHelpers)
                      CategoryItem(
                        isSelected: settingCategory == SettingCategory.qaToolbox,
                        title: SettingCategory.qaToolbox.trKey,
                        onTap: () => updateSelectedCategory(context, SettingCategory.qaToolbox),
                      ),
                  ],
                ).expanded(),
                AppVersion(headerText: LocaleKeys.appVersion.tr()),
                ApiVersion(headerText: LocaleKeys.apiVersion.tr()),
              ],
            )
            .padding(horizontal: 40, vertical: 40)
            .backgroundColor(context.c.isDarkMode ? Palette.darkIndigo : Palette.grayContainer);
      },
    );
  }
}
