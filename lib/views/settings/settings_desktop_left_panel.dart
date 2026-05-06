import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
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

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: theme.palette.borderSecondary, width: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            backLabel: LocaleKeys.backHomeLbl.tr(),
            backgroundColor: theme.palette.bgSidePanel,
          ),
          Text(
            LocaleKeys.settings.tr(),
            style: theme.textStyles.displayXlg.semibold.copyWith(
              color: theme.palette.textSecondary,
            ),
          ).padding(horizontal: theme.spacing.xl3, bottom: theme.spacing.xl3),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final category in SettingCategory.values)
                    if (category != SettingCategory.qaToolbox || enableQaHelpers)
                      NavItem(
                        icon: Icon(category.icon, size: 20),
                        label: category.trKey.tr(),
                        current: settingCategory == category,
                        onTap: () => _updateCategory(ref, category),
                      ),
                  NavItem(
                    icon: const Icon(UntitledUI.message_question_square, size: 20),
                    label: LocaleKeys.helpSupportLbl.tr(),
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
      ).backgroundColor(theme.palette.bgSidePanel),
    ).width(346);
  }

  void _updateCategory(WidgetRef ref, SettingCategory category) {
    ref.read(selectedCategoryProvider.notifier).category = category;
  }
}
