import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedPageView extends StatelessWidget {
  const UnauthenticatedPageView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenType = ScreenType.of(context);
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
