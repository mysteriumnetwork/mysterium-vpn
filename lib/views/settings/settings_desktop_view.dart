import 'package:flutter/material.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_left_panel.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_right_panel.dart';

class SettingsDesktopView extends StatelessWidget {
  const SettingsDesktopView({super.key});

  @override
  Widget build(BuildContext context) => const Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SettingsDesktopLeftPanel(),
      Expanded(child: SettingsDesktopRightPanel()),
    ],
  );
}
