import 'package:mysterium_vpn/core/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_size_breakpoints.dart';

/// Keeps the configuration that will determines the breakpoints for different device sizes
class BreakpointConfiguration {
  static const ScreenBreakpoint _defaultScreenBreakpoints = ScreenBreakpoint(
    desktop: 950,
    tablet: 750,
    mobile: 420,
    watch: 300,
  );

  static ScreenBreakpoint? _customScreenBreakpoints;

  static const ScreenSizeBreakpoint _deafultScreenSizeBreakpoints = ScreenSizeBreakpoint();

  static ScreenSizeBreakpoint? _customScreenSizeBreakpoints;

  /// Set the breakpoints which will then be returned through the [screenBreakpoints]
  void setCustomBreakpoints(
    ScreenBreakpoint? customScreenBreakpoint, {
    ScreenSizeBreakpoint? customScreenSizeBreakpoint,
  }) {
    _customScreenBreakpoints = customScreenBreakpoint;
    if (customScreenSizeBreakpoint != null) {
      _customScreenSizeBreakpoints = customScreenSizeBreakpoint;
    }
  }

  static ScreenBreakpoint get screenBreakpoints =>
      _customScreenBreakpoints ?? _defaultScreenBreakpoints;

  static ScreenSizeBreakpoint get screenSizeBreakpoints =>
      _customScreenSizeBreakpoints ?? _deafultScreenSizeBreakpoints;
}
