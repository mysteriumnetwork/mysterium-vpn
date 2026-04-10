import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/core/configurations/screen_size_configuration.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';

/// A widget with a builder that provides you with the screenSizeConfiguration
///
/// This widget is used by the ScreenTypeLayoutBuilder to provide different widget builders
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    required this.builder,
    this.screenBreakpoints,
    this.screenSizeBreakpoints,
    super.key,
  });
  final Widget Function(BuildContext context, ScreenSizeConfiguration screenSizeConfiguration)
  builder;
  final ScreenBreakpoint? screenBreakpoints;
  final ScreenSizeBreakpoint? screenSizeBreakpoints;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, boxConstraints) => builder(
      context,
      ScreenSizeConfiguration(
        screenType: getScreenType(MediaQuery.of(context).size, screenBreakpoints),
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
