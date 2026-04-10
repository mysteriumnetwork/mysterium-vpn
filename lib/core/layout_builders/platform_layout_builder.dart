import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';

/// A widget with a builder that provides you with the platform
///
/// This widget is used by the PlatformTypeLayoutBuilder to provide different widget builders
class PlatformLayoutBuilder extends StatelessWidget {
  const PlatformLayoutBuilder({
    required this.builder,
    this.screenBreakpoints,
    this.screenSizeBreakpoints,
    super.key,
  });
  final Widget Function(BuildContext context, TargetPlatform platform) builder;
  final ScreenBreakpoint? screenBreakpoints;
  final ScreenSizeBreakpoint? screenSizeBreakpoints;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, boxConstraints) => builder(context, getPlatform()));
}
