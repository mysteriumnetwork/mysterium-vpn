import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Provides a builder function for different screen types
///
/// Each builder will get built based on the current device width.
/// [watch] will be built and shown when width is less than 300
/// [mobile] will be built when width greater than 300
/// [tablet] will be built when width is greater than 650
/// [desktop] will be built if width is greater than 950
class ScreenTypeLayoutBuilder extends StatelessWidget {
  const ScreenTypeLayoutBuilder({
    required this.mobile,
    this.watch,
    this.tablet,
    this.desktop,
    super.key,
  });

  final WidgetBuilder? watch;
  final WidgetBuilder? mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final screenType = ScreenType.of(context);

    if (screenType == ScreenType.desktop) {
      if (desktop != null) {
        return desktop!(context);
      }
      if (tablet != null) {
        return tablet!(context);
      }
    }

    if (screenType == ScreenType.tablet) {
      if (tablet != null) {
        return tablet!(context);
      }
    }

    if (screenType == ScreenType.watch && watch != null) {
      return watch!(context);
    }

    return mobile != null ? mobile!(context) : const SizedBox.shrink();
  }
}
