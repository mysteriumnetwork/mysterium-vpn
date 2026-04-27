import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

export 'comparator_utils.dart';
export 'debouncer.dart';
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

void showSnackbar(String message, {SnackbarType type = SnackbarType.error, Widget? action}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    duration: action != null ? const Duration(seconds: 10) : const Duration(seconds: 4),
    content: Snackbar(message: message, type: type, action: action),
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
      action: IconButton(
        icon: const Icon(Icons.copy, size: 16),
        onPressed: () => FlutterClipboard.copy(
          url.toString(),
        ).then((value) => showSnackbar(LocaleKeys.linkCopied.tr(), type: SnackbarType.success)),
      ),
      type: SnackbarType.info,
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
