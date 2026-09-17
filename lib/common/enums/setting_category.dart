import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Identifies a settings sub-page. The widget each one renders lives in the
/// `SettingCategoryPresentation` extension in the views layer.
enum SettingCategory {
  account(icon: UntitledUI.user_03),
  connection(icon: UntitledUI.wifi),
  preferences(icon: UntitledUI.settings_04),
  qaToolbox(icon: UntitledUI.settings_04);

  const SettingCategory({required this.icon});

  final IconData icon;
}
