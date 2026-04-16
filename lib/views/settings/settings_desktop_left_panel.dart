import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopLeftPanel extends HookConsumerWidget {
  const SettingsDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingCategory = ref.watch(selectedCategoryProvider);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(() => remoteConfig.enableQaHelpers);
    final theme = Theme.of(context);
    final analyticsStore = ref.read(analyticsStorePOD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(backLabel: LocaleKeys.backHomeLbl.tr(), backgroundColor: theme.palette.bgSidePanel),
        Text(
          LocaleKeys.settings.tr(),
          style: theme.textStyles.displayXlg.semibold.copyWith(color: theme.palette.textSecondary),
        ).padding(horizontal: theme.spacing.xl3, bottom: theme.spacing.lg),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavItem(
                  icon: const Icon(UntitledUI.user_03, size: 20),
                  label: LocaleKeys.account.tr(),
                  current: settingCategory == SettingCategory.account,
                  onTap: () => _updateCategory(ref, SettingCategory.account),
                ),
                NavItem(
                  icon: const Icon(UntitledUI.wifi, size: 20),
                  label: LocaleKeys.connectionSettingLbl.tr(),
                  current: settingCategory == SettingCategory.connection,
                  onTap: () => _updateCategory(ref, SettingCategory.connection),
                ),
                NavItem(
                  icon: const Icon(UntitledUI.settings_04, size: 20),
                  label: LocaleKeys.preferences.tr(),
                  current: settingCategory == SettingCategory.preferences,
                  onTap: () => _updateCategory(ref, SettingCategory.preferences),
                ),
                if (enableQaHelpers)
                  NavItem(
                    icon: const Icon(UntitledUI.settings_04, size: 20),
                    label: 'QA Toolbox',
                    current: settingCategory == SettingCategory.qaToolbox,
                    onTap: () => _updateCategory(ref, SettingCategory.qaToolbox),
                  ),
                NavItem(
                  icon: const Icon(UntitledUI.message_question_square, size: 20),
                  label: 'Help & Support',
                  trailing: Icon(
                    UntitledUI.link_external_02,
                    size: 16,
                    color: theme.palette.iconTertiary,
                  ),
                  onTap: () =>
                      handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                ),
              ],
            ),
          ),
        ),
        const AppVersion(),
      ],
    ).backgroundColor(theme.palette.bgSidePanel).width(346);
  }

  void _updateCategory(WidgetRef ref, SettingCategory category) {
    ref.read(selectedCategoryProvider.notifier).category = category;
  }
}
