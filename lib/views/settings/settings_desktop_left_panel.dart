import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

/// Category highlighted on initial load before the user picks one (desktop's
/// left panel always shows a selected entry; mobile defaults to the main
/// list, so the shared store starts at `null`).
const _defaultDesktopCategory = SettingCategory.account;

class SettingsDesktopLeftPanel extends HookConsumerWidget {
  const SettingsDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsStore = ref.watch(homeTabsStorePOD);
    final settingCategory = useComputedValue(
      () => tabsStore.settingsSubPage ?? _defaultDesktopCategory,
    );
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.xl3,
              vertical: theme.spacing.xl,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    S.current.settings,
                    maxLines: 1,
                    minFontSize: 20,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyles.displayXlg.semibold.copyWith(
                      color: theme.palette.textPrimary,
                    ),
                  ),
                ),
                const HelpSupportIconButton(),
              ],
            ),
          ),
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
                        label: category.label,
                        current: settingCategory == category,
                        onTap: () => tabsStore.openSettingsSubPage(category),
                      ),
                  NavItem(
                    icon: const Icon(UntitledUI.message_question_square, size: 20),
                    label: S.current.helpSupportLbl,
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
}
