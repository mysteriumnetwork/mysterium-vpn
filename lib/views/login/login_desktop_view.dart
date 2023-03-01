import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view_left_panel.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view_right_panel.dart';

class LoginDesktopView extends StatelessWidget {
  const LoginDesktopView({super.key});

  @override
  Widget build(BuildContext context) => const DesktopPanelsLayout(
        leftPanel: LoginDesktopViewLeftPanel(),
        rightPanel: LoginDesktopViewRightPanel(),
        rightPanelFlex: 2,
      );
}
