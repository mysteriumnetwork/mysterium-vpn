import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsStore = ref.watch(homeTabsStorePOD);
    final subPage = useComputedValue(() => tabsStore.settingsSubPage);

    final theme = Theme.of(context);
    final body = subPage == null
        ? const _SettingsMainList()
        : _SettingsSubPageContent(category: subPage);

    return body.backgroundColor(theme.palette.bgSidePanel);
  }
}

class _SettingsMainList extends HookConsumerWidget {
  const _SettingsMainList();

  static const _categories = [
    SettingCategory.account,
    SettingCategory.connection,
    SettingCategory.preferences,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsStore = ref.read(homeTabsStorePOD);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(() => remoteConfig.enableQaHelpers);
    final analyticsStore = ref.read(analyticsStorePOD);
    final theme = Theme.of(context);

    Widget categoryCard(SettingCategory category, SettingsCardPosition position) {
      void onTap() => tabsStore.openSettingsSubPage(category);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SettingsCard(
          position: position,
          icon: Icon(category.icon, size: 20),
          title: category.trKey.tr(),
          trailing: IconButton(
            onPressed: onTap,
            icon: Icon(UntitledUI.chevron_right, size: 24, color: theme.palette.iconTertiary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PromoBanner(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            child: Column(
              children: [
                const AppVersionUpdateSetting(),
                for (final (index, category) in _categories.indexed)
                  categoryCard(
                    category,
                    index == 0 ? SettingsCardPosition.top : SettingsCardPosition.middle,
                  ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                  child: SettingsCard(
                    icon: const Icon(UntitledUI.message_question_square, size: 20),
                    title: LocaleKeys.helpSupportLbl.tr(),
                    position: SettingsCardPosition.bottom,
                    trailing: IconButton(
                      onPressed: () =>
                          handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                      icon: Icon(
                        UntitledUI.link_external_02,
                        size: 24,
                        color: theme.palette.iconTertiary,
                      ),
                    ),
                  ),
                ),
                if (enableQaHelpers)
                  categoryCard(
                    SettingCategory.qaToolbox,
                    SettingsCardPosition.single,
                  ).padding(top: theme.spacing.md),
              ],
            ),
          ),
        ),
        const AppVersion(),
      ],
    );
  }
}

class _SettingsSubPageContent extends StatelessWidget {
  const _SettingsSubPageContent({required this.category});

  final SettingCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleSliver = SliverPadding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.md,
        theme.spacing.ms,
        theme.spacing.md,
        theme.spacing.xl2,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          category.trKey.tr(),
          style: theme.textStyles.displayXlg.semibold.copyWith(
            color: theme.palette.textPrimary,
            fontSize: 24,
            height: 28 / 24,
          ),
        ),
      ),
    );

    final contentSliver = category == SettingCategory.account
        ? const AccountSettings(asSliver: true)
        : SliverPadding(
            padding: EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.xl),
            sliver: SliverToBoxAdapter(child: category.content),
          );

    return CustomScrollView(slivers: [titleSliver, contentSliver]);
  }
}
