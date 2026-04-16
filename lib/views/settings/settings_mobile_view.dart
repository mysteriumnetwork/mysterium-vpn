import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/banners/promotional_banner.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/setting_category.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  static const _mainCategories = [
    SettingCategory.account,
    SettingCategory.connection,
    SettingCategory.preferences,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(() => remoteConfig.enableQaHelpers);
    final analyticsStore = ref.read(analyticsStorePOD);
    final theme = Theme.of(context);

    void pushSubPage(String title, Widget content, {bool scrollable = true}) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (routeContext) => Theme(
            data: DesignSystemTheme.of(routeContext),
            child: _MobileSettingsSubPage(title: title, scrollable: scrollable, child: content),
          ),
        ),
      );
    }

    Widget categoryCard(SettingCategory category, SettingsCardPosition position) {
      void onTap() =>
          pushSubPage(category.trKey.tr(), category.content, scrollable: category.scrollable);
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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            backLabel: LocaleKeys.backHomeLbl.tr(),
            backgroundColor: theme.palette.bgSidePanel,
          ),
          const PromoBanner(),
          Text(
            LocaleKeys.settings.tr(),
            style: theme.textStyles.displayXlg.semibold.copyWith(color: theme.palette.textPrimary),
          ).padding(horizontal: theme.spacing.md, bottom: theme.spacing.xl2, top: theme.spacing.ms),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
              child: Column(
                children: [
                  const AppVersionUpdateSetting(),
                  for (final (index, category) in _mainCategories.indexed)
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
      ),
    ).backgroundColor(theme.palette.bgSidePanel);
  }
}

class _MobileSettingsSubPage extends StatelessWidget {
  const _MobileSettingsSubPage({required this.title, required this.child, this.scrollable = true});

  final String title;
  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.palette.bgSidePanel,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              backLabel: LocaleKeys.backToSettingsLbl.tr(),
              backgroundColor: theme.palette.bgSidePanel,
            ),
            Text(
              title,
              style: theme.textStyles.displayXlg.semibold.copyWith(
                color: theme.palette.textPrimary,
              ),
            ).padding(horizontal: theme.spacing.md, bottom: theme.spacing.xl),
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                      child: child,
                    )
                  : child,
            ),
            const AppVersion(),
          ],
        ),
      ),
    );
  }
}
