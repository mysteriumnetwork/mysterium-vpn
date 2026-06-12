import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/snackbar.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // Best-effort: await so failures are contained here instead of escaping as
  // unhandled async errors, and never throw (e.g. unsupported platform).
  try {
    await OpenStore.instance.open(
      appStoreId: appStoreId,
      appStoreIdMacOS: appStoreIdMacOS,
      androidAppBundleId: androidAppBundleId,
      windowsProductId: windowsProductId,
    );
  } catch (_) {
    // The store may be unavailable on this platform; nothing actionable.
  }
}

void handleOnSupportPage({required BuildContext context, required AnalyticsStore analyticsStore}) {
  analyticsStore.logEvent(AnalyticsEvent.openSupport);
  openUrlLink(Uri.parse('https://help.mysteriumvpn.com/'));
}
