import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/features/settings/views/settings_desktop_view.dart';
import 'package:mysterium_vpn/features/settings/views/settings_mobile_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: Theme.of(context).primaryColor,
    forceBackgroundColor: true,
    body: ScreenTypeLayoutBuilder(
      mobile: (BuildContext context) => const SettingsMobileView(),
      tablet: (BuildContext context) => const SettingsDesktopView(),
      desktop: (BuildContext context) => const SettingsDesktopView(),
    ),
  );
}
