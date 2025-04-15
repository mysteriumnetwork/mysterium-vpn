import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/sheet_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';

class SettingsMobileView extends ConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SheetScaffold(
        headerTitle: LocaleKeys.settings.tr(),
        sliver: Column(
          children: [
            HeaderTitle(text: LocaleKeys.connection.tr()),
            const ConnectionSettings(),
            HeaderTitle(text: LocaleKeys.application.tr()),
            const ApplicationSettings(),
            HeaderTitle(text: LocaleKeys.account.tr()),
            const AccountSettings(),
            if (ref.watch(environmentPOD).isDev) ...[
              const HeaderTitle(text: 'QA Toolbox'),
              const QAToolbox(),
            ],
          ],
        ),
      );
}
