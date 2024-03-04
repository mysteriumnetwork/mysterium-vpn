import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/common/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/common/configurations/breakpoint_configuration.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/auth_page.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

bool checkMediaWidth(BuildContext context, double width) =>
    MediaQuery.of(context).size.width < width;

bool checkMediaHeight(BuildContext context, double height) =>
    MediaQuery.of(context).size.height < height;

double getMediaWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getMediaHeight(BuildContext context) => MediaQuery.of(context).size.height;

EdgeInsets getWindowPadding() =>
    MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).padding;

double getWindowHeight() =>
    MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.height;

/// Returns the [ScreenType] that the application is currently running on
ScreenType getScreenType(
  Size size, [
  ScreenBreakpoint? breakpoint,
]) {
  var deviceWidth = size.width;

  if (kIsWeb || isDesktop()) {
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

bool isDesktop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
  } else if (Platform.isIOS || Platform.isMacOS) {
    return 'apple';
  } else {
    return '';
  }
}

bool isMobilePaymentGateway(String? gateway) {
  if (gateway == 'google' || gateway == 'apple') {
    return true;
  }
  return false;
}

void showSnackbar(String message, {SnackBarAction? action, MessageType type = MessageType.error}) {
  final snackBar = SnackBar(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: switch (type) {
      MessageType.error => Palette.pink,
      MessageType.info => Palette.darkBlue,
      MessageType.success => Palette.green,
    },
    content: Center(
      child: EasyText(
        message,
        maxLines: 3,
        color: Palette.white,
        fontWeight: FontWeight.w900,
        textAlign: TextAlign.center,
      ),
    ),
    action: action,
  );

  snackbarKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(snackBar);
}

String? getMagicLinkCode(String query) {
  if (!query.contains('code=') ||
      !query.substring(query.indexOf('code=') + 5, query.length).isUUID()) {
    return null;
  }
  return query.substring(query.indexOf('code=') + 5, query.length);
}

void handleOnSignIn(BuildContext context, AuthStore store) {
  if (isWindowsOrLinux()) {
    store.loginDesktop();
    return;
  }
  showBarModalBottomSheet(
    context: context,
    animationCurve: Curves.easeInOut,
    backgroundColor: Palette.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const SignUpPage().height(getMediaHeight(context) * 0.9),
      ),
    ),
  );
}

void handleOnBillingPage({
  required BuildContext context,
  required bool subscriptionActive,
  required String billingPage,
  required String? gateway,
  required String? accessToken,
}) {
  final isMobileGateway = isMobilePaymentGateway(gateway);

  if (subscriptionActive && isMobileGateway) {
    if (gateway != getPlatformGateway()) {
      showSnackbar(
        LocaleKeys.activeSubsPaidVia.tr(
          namedArgs: {
            'store': Platform.isIOS ? 'Google Play Store' : 'Apple App Store',
          },
        ),
      );
      return;
    }
    context.beamToNamed(Routes.subscription.toRoute);
    return;
  }

  if (!subscriptionActive && !Platform.isWindows) {
    context.beamToNamed(Routes.subscription.toRoute);
    return;
  }

  final uri = Uri.parse(billingPage);
  final httpsUri = Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: {
      'access_token': accessToken ?? '',
    },
  );

  launchUrl(httpsUri);
}

void handleOnReportPage({
  required BuildContext context,
  required IntercomStore intetcomStore,
}) {
  intetcomStore.displayMessenger();
}

SubscriptionStatus getSubscriptionStatus(PurchaseStatus status) => switch (status) {
      PurchaseStatus.purchased => SubscriptionStatus.purchased,
      PurchaseStatus.pending => SubscriptionStatus.pending,
      PurchaseStatus.error => SubscriptionStatus.error,
      PurchaseStatus.restored => SubscriptionStatus.restored,
      PurchaseStatus.canceled => SubscriptionStatus.canceled
    };

Future<void> openUrlLink(Uri url) async {
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    showSnackbar(
      LocaleKeys.copyLink.tr(),
      action: SnackBarAction(
        textColor: Palette.purple,
        label: LocaleKeys.copyBtn.tr(),
        onPressed: () => FlutterClipboard.copy(url.toString()).then(
          (value) => showSnackbar(
            LocaleKeys.linkCopied.tr(),
            type: MessageType.success,
          ),
        ),
      ),
      type: MessageType.info,
    );
  }
}

Future<bool> hasNetwork() async {
  var counter = 0;
  var isOnline = false;
  await Future.doWhile(() async {
    counter++;
    if (counter == 3 || isOnline) {
      return false;
    }
    await Future.delayed(const Duration(seconds: 1));
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return false;
  });
  return isOnline;
}
