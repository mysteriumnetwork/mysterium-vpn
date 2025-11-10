import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/animated_logo_panel.dart';
import 'package:mysterium_vpn/components/desktop_panels_layout.dart';

class UnauthenticatedPageView extends HookWidget {
  const UnauthenticatedPageView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final showPanel = useResponsiveValue(false, desktop: true);

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
