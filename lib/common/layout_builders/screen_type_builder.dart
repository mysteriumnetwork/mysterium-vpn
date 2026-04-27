import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/responsive_layout_builder.dart';
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
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
    builder: (context, sizingInformation) {
      // If we're at desktop size
      if (sizingInformation.screenType == ScreenType.desktop) {
        // If we have supplied the desktop layout then display that
        if (desktop != null) {
          return desktop!(context);
        }
        // If no desktop layout is supplied we want to check if we have the size below it and display that
        if (tablet != null) {
          return tablet!(context);
        }
      }

      if (sizingInformation.screenType == ScreenType.tablet) {
        if (tablet != null) {
          return tablet!(context);
        }
      }

      if (sizingInformation.screenType == ScreenType.watch && watch != null) {
        return watch!(context);
      }

      // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
      return mobile != null ? mobile!(context) : const SizedBox.shrink();
    },
  );
}
