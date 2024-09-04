import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view_left_panel.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view_right_panel.dart';

class LoginDesktopView extends StatelessWidget {
  const LoginDesktopView({
    required this.onSignIn,
    required this.onReport,
    super.key,
  });
  final VoidCallback onSignIn;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => DesktopPanelsLayout(
        leftPanel: LoginDesktopViewLeftPanel(
          onSignInPressed: onSignIn,
          onReportPressed: onReport,
        ),
        rightPanel: const LoginDesktopViewRightPanel(),
        rightPanelFlex: 2,
      );
}
