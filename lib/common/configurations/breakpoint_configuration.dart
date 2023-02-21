import 'package:mysterium_vpn/common/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';

/// Keeps the configuration that will determines the breakpoints for different device sizes
class BreakpointConfiguration {
  static BreakpointConfiguration? _instance;
  static BreakpointConfiguration get instance {
    _instance ??= BreakpointConfiguration();
    return _instance!;
  }

  static const ScreenBreakpoint _defaultScreenBreakpoints = ScreenBreakpoint(
    desktop: 950,
    tablet: 700,
    mobile: 420,
    watch: 300,
  );

  ScreenBreakpoint? _customScreenBreakpoints;

  static const ScreenSizeBreakpoint _deafultScreenSizeBreakpoints = ScreenSizeBreakpoint(
    // Desktop
    desktopExtraLarge: 4096,
    desktopLarge: 3840,
    desktopNormal: 1920,
    desktopSmall: 950,
    // Tablet
    tabletExtraLarge: 900,
    tabletLarge: 850,
    tabletNormal: 768,
    tabletSmall: 650,
    // Mobile
    mobileExtraLarge: 480,
    mobileLarge: 414,
    mobileNormal: 375,
    mobileSmall: 320,
  );

  ScreenSizeBreakpoint? _customScreenSizeBreakpoints;

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

  ScreenBreakpoint get screenBreakpoints => _customScreenBreakpoints ?? _defaultScreenBreakpoints;

  ScreenSizeBreakpoint get screenSizeBreakpoints => _customScreenSizeBreakpoints ?? _deafultScreenSizeBreakpoints;
}
