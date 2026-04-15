import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/shared/components/animated_logo_panel.dart';
import 'package:mysterium_vpn/shared/components/desktop_panels_layout.dart';

class UnauthenticatedPageView extends StatelessWidget {
  const UnauthenticatedPageView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final showPanel = screenType >= ScreenType.desktop;

    if (!showPanel) {
      return child;
    }

    return DesktopPanelsLayout(
      leftPanel: child,
      rightPanel: const AnimatedLogoPanel(),
      leftPanelFlex: 1,
      rightPanelFlex: 1,
    );
  }
}
