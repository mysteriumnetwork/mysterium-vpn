import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';
import 'package:mysterium_vpn/views/welcome/welcome_desktop_view_left_panel.dart';
import 'package:mysterium_vpn/views/welcome/welcome_desktop_view_right_panel.dart';

class WelcomeDesktopView extends StatelessWidget {
  const WelcomeDesktopView({
    required this.onSignIn,
    super.key,
  });
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => DesktopPanelsLayout(
        leftPanel: WelcomeDesktopViewLeftPanel(
          onSignInPressed: onSignIn,
        ),
        rightPanel: const WelcomeDesktopViewRightPanel(),
        rightPanelFlex: 2,
      );
}
