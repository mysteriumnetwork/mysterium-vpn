import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_breakpoints.dart';
import 'package:mysterium_vpn/core/breakpoints/screen_size_breakpoints.dart';
import 'package:mysterium_vpn/core/configurations/breakpoint_configuration.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

export 'comparator_utils.dart';
export 'debouncer.dart';
export 'design_system_theme.dart';
export 'disposeable.dart';
export 'keys.dart';
export 'mocks.dart';
export 'replay_stream_controller.dart';
export 'resolve_error_msg.dart';
export 'semantic_version.dart';
export 'translation_asset_loader.dart';
export 'uuid.dart';

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
ScreenType getScreenType(Size size, [ScreenBreakpoint? breakpoint]) {
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
SizeType getSizeType(Size size, {ScreenSizeBreakpoint? screenSizeBreakpoint}) {
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

bool isMacOSOrIOS() => Platform.isMacOS || Platform.isIOS;

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

void showSnackbar(
  String message, {
  SnackBarAction? action,
  MessageType type = MessageType.error,
  TextAlign textAlign = TextAlign.center,
}) {
  final snackBar = SnackBar(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        fontWeight: FontWeight.w600,
        textAlign: textAlign,
      ),
    ),
    action: action,
  );

  snackbarKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(snackBar);
}

void showError(Object? error) {
  showSnackbar(error?.toString() ?? LocaleKeys.somethingWentWrong.tr());
}

String? getMagicLinkCode(String query) {
  if (!query.contains('code=') ||
      !query.substring(query.indexOf('code=') + 5, query.length).isUUID()) {
    return null;
  }
  return query.substring(query.indexOf('code=') + 5, query.length);
}

FutureOr<void> handleOnBillingPage({
  required BuildContext context,
  required bool subscriptionActive,
  required String manageSubscriptionPage,
  required String upgradeSubscriptionPage,
  required String? gateway,
  required String? accessToken,
  required bool manageSubscription,
  FutureOr<void> Function()? onManageSubscription,
}) async {
  final isMobileGateway = isMobilePaymentGateway(gateway);

  if (subscriptionActive && isMobileGateway) {
    if (gateway != getPlatformGateway()) {
      showSnackbar(
        LocaleKeys.activeSubsPaidVia.tr(
          namedArgs: {'store': Platform.isIOS ? 'Google Play Store' : 'Apple App Store'},
        ),
      );
      return;
    }
    await onManageSubscription?.call();
    return;
  }

  if (!subscriptionActive && !Platform.isWindows) {
    await showSubscriptionUpgradeModalPage(context);
    return;
  }

  final uri = Uri.parse(manageSubscription ? manageSubscriptionPage : upgradeSubscriptionPage);
  final httpsUri = Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: {'access_token': accessToken ?? ''},
  );

  await openUrlLink(httpsUri);
}

void handleOnSupportPage({required BuildContext context, required AnalyticsStore analyticsStore}) {
  analyticsStore.logEvent(AnalyticsEvent.openSupport);
  openUrlLink(Uri.parse('https://help.mysteriumvpn.com/'));
}

/// Opens a URL link in the default browser.
/// If the URL cannot be launched, it copies the URL to the clipboard and shows a snackbar.
/// [url] is the URL to be opened.
/// [mode] specifies how the URL should be launched (for example, using the
/// platform default, an in-app web view, or an external application). The
/// default is [LaunchMode.platformDefault].
Future<void> openUrlLink(Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: mode);
    } else {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    showSnackbar(
      LocaleKeys.copyLink.tr(),
      action: SnackBarAction(
        textColor: Palette.purple,
        label: LocaleKeys.copyBtn.tr(),
        onPressed: () => FlutterClipboard.copy(
          url.toString(),
        ).then((value) => showSnackbar(LocaleKeys.linkCopied.tr(), type: MessageType.success)),
      ),
      type: MessageType.info,
    );
  }
}

Future<void> openAppStorePage() async {
  OpenStore.instance.open(
    appStoreId: appStoreId,
    appStoreIdMacOS: appStoreIdMacOS,
    androidAppBundleId: androidAppBundleId,
    windowsProductId: windowsProductId,
  );
}

String generateRandomString(int len) {
  final r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
}
