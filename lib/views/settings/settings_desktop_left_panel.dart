import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/api_version.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/desktop_page_header.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/category_item.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopLeftPanel extends HookConsumerWidget {
  const SettingsDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingCategory = ref.watch(selectedCategoryProvider);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(() => remoteConfig.enableQaHelpers);
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesktopPageHeader(
              onPressed: () => handleOnSupportPage(
                context: context,
                analyticsStore: ref.read(analyticsStorePOD),
              ),
              asset: Asset.icons.reportAdaptive(context),
            ).padding(bottom: 10),
            ListView(
              shrinkWrap: true,
              children: [
                CategoryItem(
                  isSelected: settingCategory == SettingCategory.connection,
                  title: SettingCategory.connection.trKey.tr(),
                  onTap: () => updateSelectedCategory(ref, SettingCategory.connection),
                ),
                CategoryItem(
                  isSelected: settingCategory == SettingCategory.preferences,
                  title: SettingCategory.preferences.trKey.tr(),
                  onTap: () => updateSelectedCategory(ref, SettingCategory.preferences),
                ),
                CategoryItem(
                  isSelected: settingCategory == SettingCategory.account,
                  title: SettingCategory.account.trKey.tr(),
                  onTap: () => updateSelectedCategory(ref, SettingCategory.account),
                ),
                if (enableQaHelpers)
                  CategoryItem(
                    isSelected: settingCategory == SettingCategory.qaToolbox,
                    title: SettingCategory.qaToolbox.trKey,
                    onTap: () => updateSelectedCategory(ref, SettingCategory.qaToolbox),
                  ),
              ],
            ).expanded(),
            AppVersion(headerText: LocaleKeys.appVersion.tr()),
            ApiVersion(headerText: LocaleKeys.apiVersion.tr()),
          ],
        )
        .padding(horizontal: 40, vertical: 40)
        .backgroundColor(context.c.isDarkMode ? Palette.darkIndigo : Palette.grayContainer);
  }

  void updateSelectedCategory(WidgetRef ref, SettingCategory category) {
    ref.read(selectedCategoryProvider.notifier).category = category;
  }
}
