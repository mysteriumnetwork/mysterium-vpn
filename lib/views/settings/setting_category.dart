import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum SettingCategory {
  account(trKey: LocaleKeys.account, icon: UntitledUI.user_03),
  connection(trKey: LocaleKeys.connectionSettingLbl, icon: UntitledUI.wifi),
  preferences(trKey: LocaleKeys.preferences, icon: UntitledUI.settings_04),
  qaToolbox(trKey: LocaleKeys.qaToolboxLbl, icon: UntitledUI.settings_04);

  const SettingCategory({required this.trKey, required this.icon});
  final String trKey;
  final IconData icon;

  Widget get content => switch (this) {
    account => const AccountSettings(),
    connection => const ConnectionSettings(),
    preferences => const ApplicationSettings(),
    qaToolbox => const QAToolbox(),
  };
}
