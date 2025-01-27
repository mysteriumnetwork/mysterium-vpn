import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/sheet_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';

class SettingsMobileView extends StatelessWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context) => SheetScaffold(
        headerTitle: LocaleKeys.settings.tr(),
        sliver: Column(
          children: [
            HeaderTitle(text: LocaleKeys.connection.tr()),
            const ConnectionSettings(),
            HeaderTitle(text: LocaleKeys.application.tr()),
            const ApplicationSettings(),
            HeaderTitle(text: LocaleKeys.account.tr()),
            const AccountSettings(),
          ],
        ),
      );
}
