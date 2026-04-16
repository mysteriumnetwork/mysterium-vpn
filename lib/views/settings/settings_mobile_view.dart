import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(() => remoteConfig.enableQaHelpers);
    final analyticsStore = ref.read(analyticsStorePOD);
    final theme = Theme.of(context);

    void pushSubPage(String title, Widget content, {bool scrollable = true}) {
      final capturedTheme = Theme.of(context);
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Theme(
            data: capturedTheme,
            child: _MobileSettingsSubPage(title: title, scrollable: scrollable, child: content),
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
          Text(
            LocaleKeys.settings.tr(),
            style: theme.textStyles.displayXlg.semibold.copyWith(color: theme.palette.textPrimary),
          ).padding(horizontal: theme.spacing.md, bottom: theme.spacing.xl2, top: theme.spacing.ms),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => pushSubPage(
                      LocaleKeys.account.tr(),
                      const AccountSettings(),
                      scrollable: false,
                    ),
                    child: SettingsCard(
                      position: SettingsCardPosition.top,
                      icon: const Icon(UntitledUI.user_03, size: 20),
                      title: LocaleKeys.account.tr(),
                      trailing: IconButton(
                        onPressed: () => pushSubPage(
                          LocaleKeys.account.tr(),
                          const AccountSettings(),
                          scrollable: false,
                        ),
                        icon: Icon(
                          UntitledUI.chevron_right,
                          size: 24,
                          color: theme.palette.iconTertiary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pushSubPage(
                      LocaleKeys.connectionSettingLbl.tr(),
                      const ConnectionSettings(),
                    ),
                    child: SettingsCard(
                      icon: const Icon(UntitledUI.wifi, size: 20),
                      title: LocaleKeys.connectionSettingLbl.tr(),
                      position: SettingsCardPosition.middle,
                      trailing: IconButton(
                        onPressed: () => pushSubPage(
                          LocaleKeys.connectionSettingLbl.tr(),
                          const ConnectionSettings(),
                        ),
                        icon: Icon(
                          UntitledUI.chevron_right,
                          size: 24,
                          color: theme.palette.iconTertiary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        pushSubPage(LocaleKeys.preferences.tr(), const ApplicationSettings()),
                    child: SettingsCard(
                      icon: const Icon(UntitledUI.settings_04, size: 20),
                      title: LocaleKeys.preferences.tr(),
                      position: SettingsCardPosition.middle,
                      trailing: IconButton(
                        onPressed: () =>
                            pushSubPage(LocaleKeys.preferences.tr(), const ApplicationSettings()),
                        icon: Icon(
                          UntitledUI.chevron_right,
                          size: 24,
                          color: theme.palette.iconTertiary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        handleOnSupportPage(context: context, analyticsStore: analyticsStore),
                    child: SettingsCard(
                      icon: const Icon(UntitledUI.message_question_square, size: 20),
                      title: 'Help & Support',
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
                    GestureDetector(
                      onTap: () => pushSubPage('QA Toolbox', const QAToolbox()),
                      child: SettingsCard(
                        icon: const Icon(UntitledUI.settings_04, size: 20),
                        title: 'QA Toolbox',
                        trailing: IconButton(
                          onPressed: () => pushSubPage('QA Toolbox', const QAToolbox()),
                          icon: Icon(
                            UntitledUI.chevron_right,
                            size: 24,
                            color: theme.palette.iconTertiary,
                          ),
                        ),
                      ).padding(top: theme.spacing.md),
                    ),
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
            Header(backLabel: 'Back to Settings', backgroundColor: theme.palette.bgSidePanel),
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
