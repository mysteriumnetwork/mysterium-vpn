import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/debug/qa_toolbox.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';

/// View-layer presentation for [SettingCategory].
extension SettingCategoryPresentation on SettingCategory {
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
