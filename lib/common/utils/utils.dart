import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/common/configurations/breakpoint_configuration.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/dialogs/no_internet_connection_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';

bool checkMediaWidth(BuildContext context, double width) =>
    MediaQuery.of(context).size.width < width;

bool checkMediaHeight(BuildContext context, double height) =>
    MediaQuery.of(context).size.height < height;

double getMediaWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getMediaHeight(BuildContext context) => MediaQuery.of(context).size.height;

EdgeInsets getWindowPadding() => MediaQueryData.fromWindow(window).padding;

double getWindowHeight() => MediaQueryData.fromWindow(window).size.height;

/// Returns the [ScreenType] that the application is currently running on
ScreenType getScreenType(
  Size size, [
  ScreenBreakpoint? breakpoint,
]) {
  var deviceWidth = size.width;

  if (kIsWeb || isDekstop()) {
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
    if (deviceWidth >= BreakpointConfiguration.screenBreakpoints.desktop) {
      return ScreenType.desktop;
    }

    if (deviceWidth >= BreakpointConfiguration.screenBreakpoints.tablet) {
      return ScreenType.tablet;
    }

    if (deviceWidth < BreakpointConfiguration.screenBreakpoints.watch) {
      return ScreenType.watch;
    }
  }

  return ScreenType.mobile;
}

/// Returns the [SizeType] for each device that the application is currently running on
SizeType getSizeType(
  Size size, {
  ScreenSizeBreakpoint? screenSizeBreakpoint,
}) {
  final deviceScreenType = getScreenType(size);
  final deviceWidth = size.width;

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
      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.desktopExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.desktopLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.desktopNormal) {
        return SizeType.normal;
      }
    }

    // Tablet
    if (deviceScreenType == ScreenType.tablet) {
      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.tabletExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.tabletLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.tabletNormal) {
        return SizeType.normal;
      }
    }

    // Mobile
    if (deviceScreenType == ScreenType.mobile) {
      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.mobileExtraLarge) {
        return SizeType.extraLarge;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.mobileLarge) {
        return SizeType.large;
      }

      if (deviceWidth >= BreakpointConfiguration.screenSizeBreakpoints.mobileNormal) {
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

bool isDekstop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool isMobile() => Platform.isAndroid || Platform.isIOS;

bool isWindowsOrLinux() => Platform.isWindows || Platform.isLinux;

TargetPlatform getPlatform() {
  if (Platform.isAndroid) {
    return TargetPlatform.android;
  } else if (Platform.isIOS) {
    return TargetPlatform.iOS;
  } else if (Platform.isMacOS) {
    return TargetPlatform.macOS;
  } else if (Platform.isWindows) {
    return TargetPlatform.windows;
  } else {
    return defaultTargetPlatform;
  }
}

String getPlatformGateway() {
  if (Platform.isAndroid) {
    return 'google';
  } else if (Platform.isIOS) {
    return 'apple';
  } else {
    return '';
  }
}

void showSnackbar(String message, {MessageType type = MessageType.error}) {
  final snackBar = SnackBar(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: type == MessageType.error ? Palette.pink : Palette.green,
    content: Center(
      child: EasyText(
        message,
        maxLines: 2,
        color: Palette.white,
        fontWeight: FontWeight.w900,
        textAlign: TextAlign.center,
      ),
    ),
  );

  snackbarKey.currentState?.showSnackBar(snackBar);
}

ApiException handleException(Exception e, {String? message}) {
  if (e is DioError) {
    final data = e.response?.data as Map<String, dynamic>;
    if (!data.containsKey('error')) {
      return ApiException(
        e.message ?? 'Something went wrong. Please give it another try. 😕',
      );
    }
    if ((data['error'] as Map<String, dynamic>).containsKey('message')) {
      return ApiException(data['message'] as String? ?? 'Something went wrong');
    }
    return ApiException(
      e.message ?? 'Something went wrong at our server. Please give it another try. 😕',
    );
  } else {
    return ApiException(
      message ?? 'Something went wrong with. Please give it another try. 😕',
    );
  }
}

void onConnectButtonPressed(
  ConnectivityResult connectivityStatus,
  ConnectionStatus vpnStatus,
  BuildContext context,
  VoidCallback onPressed,
) {
  if (connectivityStatus == ConnectivityResult.none && vpnStatus == ConnectionStatus.disconnected) {
    shownNoInternetConnectionDialog(context);
  } else {
    onPressed();
  }
}
