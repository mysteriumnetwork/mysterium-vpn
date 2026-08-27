import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/url_launcher.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Whether an in-app webview can be shown.
///
/// `webview_flutter` ships no Windows or Linux implementation, so no platform
/// instance is registered there and constructing a [WebViewController] throws.
/// Asking the plugin (rather than testing the host platform) keeps this correct
/// if an implementation is ever added.
bool supportsInAppWebView() => WebViewPlatform.instance != null;

/// Shows the webview screen from [builder] as a modal, falling back to [uri] in
/// the default browser when [isSupported] reports no webview.
///
/// Open every in-app webview through this so the fallback cannot be forgotten;
/// [source] tags the `web_redirect` analytics event on the browser path.
/// [isSupported] is injectable because [WebViewPlatform.instance] can only be
/// set once per process, so tests cannot reach both branches through it.
Future<void> openInAppWebView(
  BuildContext context, {
  required Uri uri,
  required RedirectSource source,
  required WidgetBuilder builder,
  bool Function() isSupported = supportsInAppWebView,
}) async {
  if (!isSupported()) {
    await openUrlLink(uri, source: source);
    return;
  }
  await showModal<void>(context, builder: builder);
}
