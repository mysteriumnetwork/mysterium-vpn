import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/sheet_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/components/banners/in_app_message_banner.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn/views/settings/version_update_setting.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final enableQaHelpers = useComputedValue(
      () => remoteConfig.enableQaHelpers,
    );
    return SheetScaffold(
      headerTitle: LocaleKeys.settings.tr(),
      subheaderSliver: const SliverPinnedHeader(child: InAppMessageBanner()),
      sliver: SliverClip(
        child: DecoratedSliver(
          decoration: BoxDecoration(
            color: context.c.isDarkMode ? Palette.darkBlue : Palette.white,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
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
              ],
            ),
          ),
        ),
      ),
    ).backgroundColor(
      context.c.isDarkMode ? Palette.darkBlue : Palette.white,
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) => EasyText(
        title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ).padding(vertical: 16, horizontal: 40);
}
