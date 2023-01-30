import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/common/configurations/breakpoint_configuration.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

bool checkMediaWidth(BuildContext context, double width) {
  return MediaQuery.of(context).size.width < width;
}

bool checkMediaHeight(BuildContext context, double height) {
  return MediaQuery.of(context).size.height < height;
}

double getMediaWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getMediaHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Returns the [ScreenType] that the application is currently running on
ScreenType getScreenType(
  Size size, [
  ScreenBreakpoint? breakpoint,
]) {
  double deviceWidth = size.shortestSide;

  if (kIsWeb) {
    deviceWidth = size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (breakpoint != null) {
    if (deviceWidth > breakpoint.desktop) {
      return ScreenType.desktop;
    }

    if (deviceWidth > breakpoint.tablet) {
      return ScreenType.tablet;
    }

    if (deviceWidth < breakpoint.watch) {
      return ScreenType.watch;
    }
  } else {
    // If no user defined definitions are passed through use the defaults
    if (deviceWidth >= BreakpointConfiguration.instance.screenBreakpoints.desktop) {
      return ScreenType.desktop;
    }

    if (deviceWidth >= BreakpointConfiguration.instance.screenBreakpoints.tablet) {
      return ScreenType.tablet;
    }

    if (deviceWidth < BreakpointConfiguration.instance.screenBreakpoints.watch) {
      return ScreenType.watch;
    }
  }

  return ScreenType.mobile;
}

/// Returns the [SizeType] for each device that the application is currently running on
SizeType getSizeType(
  Size size, {
  ScreenSizeBreakpoint? screenSizeBreakpoint,
  bool isWebOrDesktop = kIsWeb,
}) {
  final ScreenType deviceScreenType = getScreenType(size);
  double deviceWidth = size.shortestSide;

  if (isWebOrDesktop) {
    deviceWidth = size.width;
  }

  // Replaces the defaults with the user defined definitions
  if (screenSizeBreakpoint != null) {
    if (deviceScreenType == ScreenType.desktop) {
      if (deviceWidth > screenSizeBreakpoint.desktopExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth > screenSizeBreakpoint.desktopLarge) {
        return SizeType.large;
      }

      if (deviceWidth > screenSizeBreakpoint.desktopNormal) {
        return SizeType.normal;
      }
    }

    if (deviceScreenType == ScreenType.tablet) {
      if (deviceWidth > screenSizeBreakpoint.tabletExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth > screenSizeBreakpoint.tabletLarge) {
        return SizeType.large;
      }

      if (deviceWidth > screenSizeBreakpoint.tabletNormal) {
        return SizeType.normal;
      }
    }

    if (deviceScreenType == ScreenType.mobile) {
      if (deviceWidth > screenSizeBreakpoint.mobileExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth > screenSizeBreakpoint.mobileLarge) {
        return SizeType.large;
      }

      if (deviceWidth > screenSizeBreakpoint.mobileNormal) {
        return SizeType.normal;
      }
    }

    if (deviceScreenType == ScreenType.watch) {
      return SizeType.normal;
    }
  } else {
    // If no user defined definitions are passed through use the defaults

    // Desktop
    if (deviceScreenType == ScreenType.desktop) {
      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.desktopExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.desktopLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.desktopNormal) {
        return SizeType.normal;
      }
    }

    // Tablet
    if (deviceScreenType == ScreenType.tablet) {
      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.tabletExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.tabletLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.tabletNormal) {
        return SizeType.normal;
      }
    }

    // Mobile
    if (deviceScreenType == ScreenType.mobile) {
      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.mobileExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.mobileLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.instance.screenSizeBreakpoints.mobileNormal) {
        return SizeType.normal;
      }
    }
  }

  return SizeType.small;
}

/// Will return one of the values passed in for the device it's running on
T getValueForScreenType<T>({
  required BuildContext context,
  required T mobile,
  T? tablet,
  T? desktop,
  T? watch,
}) {
  final deviceScreenType = getScreenType(MediaQuery.of(context).size);
  // If we're at desktop size
  if (deviceScreenType == ScreenType.desktop) {
    // If we have supplied the desktop layout then display that
    if (desktop != null) {
      return desktop;
    }
    // If no desktop layout is supplied we want to check if we have the size below it and display that
    if (tablet != null) {
      return tablet;
    }
  }

  if (deviceScreenType == ScreenType.tablet) {
    if (tablet != null) {
      return tablet;
    }
  }

  if (deviceScreenType == ScreenType.watch && watch != null) {
    return watch;
  }

  // If none of the layouts above are supplied or we're on the mobile layout then we show the mobile layout
  return mobile;
}

/// Will return one of the values passed in for the refined size
T getValueForSizeType<T>({
  required BuildContext context,
  required T normal,
  T? large,
  T? extraLarge,
}) {
  final refinedSize = getSizeType(MediaQuery.of(context).size);
  // If we're at extra large size
  if (refinedSize == SizeType.extraLarge) {
    // If we have supplied the extra large layout then display that
    if (extraLarge != null) {
      return extraLarge;
    }
    // If no extra large layout is supplied we want to check if we have the size below it and display that
    if (large != null) {
      return large;
    }
  }

  if (refinedSize == SizeType.large) {
    // If we have supplied the large layout then display that
    if (large != null) {
      return large;
    }
    // If no large layout is supplied we want to check if we have the size below it and display that
    if (normal != null) {
      return normal;
    }
  }

  if (refinedSize == SizeType.normal) {
    // If we have supplied the normal layout then display that
    if (normal != null) {
      return normal;
    }
  }

  // If none of the layouts above are supplied or we're on the normal size layout then we show the normal layout
  return normal;
}
