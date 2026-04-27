import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/setting_category.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_view.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopLeftPanel extends StatelessWidget {
  const SettingsDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = getIt<RemoteConfigStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final theme = Theme.of(context);

    return Observer(
      builder: (context) {
        final settingCategory = readSelectedCategory(context);
        final enableQaHelpers = remoteConfig.enableQaHelpers;

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
                            onTap: () => updateSelectedCategory(context, category),
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
      },
    );
  }
}
