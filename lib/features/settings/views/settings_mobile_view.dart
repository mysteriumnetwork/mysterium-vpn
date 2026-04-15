import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/account_settings.dart';
import 'package:mysterium_vpn/features/settings/views/application_settings.dart';
import 'package:mysterium_vpn/features/settings/views/connection_settings.dart';
import 'package:mysterium_vpn/features/settings/views/qa_toolbox.dart';
import 'package:mysterium_vpn/features/settings/views/version_update_setting.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/banners/promotional_banner.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/sheet_scaffold.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends StatelessWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfig = getIt<RemoteConfigStore>();
    return Observer(
      builder: (context) {
        final enableQaHelpers = remoteConfig.enableQaHelpers;
        return SheetScaffold(
          headerTitle: LocaleKeys.settings.tr(),
          subheaderSliver: const SliverPinnedHeader(child: PromoBanner()),
          sliver: SliverPadding(
            padding: const EdgeInsets.only(bottom: 30),
            sliver: SliverClip(
              child: DecoratedSliver(
                decoration: BoxDecoration(
                  color: context.c.isDarkMode ? Palette.darkBlue : Palette.white,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const AppVersionUpdateSetting(),
                    _HeaderTitle(title: LocaleKeys.connection.tr()),
                    const ConnectionSettings(),
                    _HeaderTitle(title: LocaleKeys.application.tr()),
                    const ApplicationSettings(),
                    _HeaderTitle(title: LocaleKeys.account.tr()),
                    const AccountSettings(),
                    if (enableQaHelpers) ...[
                      const _HeaderTitle(title: 'QA Toolbox'),
                      const QAToolbox(),
                    ],
                  ]),
                ),
              ),
            ),
          ),
        ).backgroundColor(context.c.isDarkMode ? Palette.darkBlue : Palette.white);
      },
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => EasyText(
    title,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ).padding(vertical: 16, horizontal: 20);
}
