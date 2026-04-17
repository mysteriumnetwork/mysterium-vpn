import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn/views/settings/settings_mobile_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Theme(
    data: DesignSystemTheme.of(context),
    child: ColoredScaffold(
      extendBodyBehindAppBar: true,
      body: ScreenTypeLayoutBuilder(
        mobile: (BuildContext context) => const SettingsMobileView(),
        tablet: (BuildContext context) => const SettingsDesktopView(),
        desktop: (BuildContext context) => const SettingsDesktopView(),
      ),
    ),
  );
}
