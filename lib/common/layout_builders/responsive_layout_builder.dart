import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/common/configurations/screen_size_configuration.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A widget with a builder that provides you with the screenSizeConfiguration
///
/// This widget is used by the ScreenTypeLayoutBuilder to provide different widget builders
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({required this.builder, this.screenSizeBreakpoints, super.key});
  final Widget Function(BuildContext context, ScreenSizeConfiguration screenSizeConfiguration)
  builder;
  final ScreenSizeBreakpoint? screenSizeBreakpoints;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, boxConstraints) => builder(
      context,
      ScreenSizeConfiguration(
        screenType: ScreenType.of(context),
        sizeType: getSizeType(
          MediaQuery.of(context).size,
          screenSizeBreakpoint: screenSizeBreakpoints,
        ),
        screenSize: MediaQuery.of(context).size,
        localWidgetSize: Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      ),
    ),
  );
}
