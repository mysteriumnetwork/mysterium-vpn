import 'package:flutter/material.dart';
import 'package:mysterium_vpn/features/auth/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/features/auth/views/welcome_desktop_view_left_panel.dart';

class WelcomeDesktopView extends StatelessWidget {
  const WelcomeDesktopView({required this.onSignIn, super.key});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) =>
      UnauthenticatedPageView(child: WelcomeDesktopViewLeftPanel(onSignInPressed: onSignIn));
}
