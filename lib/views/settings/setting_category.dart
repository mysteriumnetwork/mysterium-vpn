import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/qa_toolbox.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// View-layer presentation for [SettingCategory].
extension SettingCategoryPresentation on SettingCategory {
  IconData get icon => switch (this) {
    SettingCategory.account => UntitledUI.user_03,
    SettingCategory.connection => UntitledUI.wifi,
    SettingCategory.preferences => UntitledUI.settings_04,
    SettingCategory.qaToolbox => UntitledUI.settings_04,
  };

  String get label => switch (this) {
    SettingCategory.account => S.current.account,
    SettingCategory.connection => S.current.connectionSettingLbl,
    SettingCategory.preferences => S.current.preferences,
    SettingCategory.qaToolbox => S.current.qaToolboxLbl,
  };

  Widget get content => switch (this) {
    SettingCategory.account => const AccountSettings(),
    SettingCategory.connection => const ConnectionSettings(),
    SettingCategory.preferences => const ApplicationSettings(),
    SettingCategory.qaToolbox => const QAToolbox(),
  };
}
