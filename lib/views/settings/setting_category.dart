import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum SettingCategory {
  account(icon: UntitledUI.user_03),
  connection(icon: UntitledUI.wifi),
  preferences(icon: UntitledUI.settings_04),
  qaToolbox(icon: UntitledUI.settings_04);

  const SettingCategory({required this.icon});
  final IconData icon;

  String get label => switch (this) {
    account => S.current.account,
    connection => S.current.connectionSettingLbl,
    preferences => S.current.preferences,
    qaToolbox => S.current.qaToolboxLbl,
  };

  Widget get content => switch (this) {
    account => const AccountSettings(),
    connection => const ConnectionSettings(),
    preferences => const ApplicationSettings(),
    qaToolbox => const QAToolbox(),
  };
}
