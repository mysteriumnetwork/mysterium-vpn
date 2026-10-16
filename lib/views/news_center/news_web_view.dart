import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/models/models.dart';

/// Parses [url] into a webview-safe [Uri], or null if it is unparseable or not
/// an http(s) URL. Rejects non-web schemes (file:, intent:, javascript:, …)
/// that a backend item URL might otherwise carry. A non-empty [userId] is
/// appended as a `user_id` query parameter.
@visibleForTesting
Uri? newsWebViewUri(String url, {String? userId}) {
  final uri = Uri.tryParse(url);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    return null;
  }
  if (userId.isNullOrEmpty) {
    return uri;
  }
  return uri.replace(queryParameters: {...uri.queryParameters, 'user_id': userId});
}

/// Opens [item]'s content in an in-app webview modal (a dialog, not a route),
/// or in the default browser where there is no webview — see
/// [openInAppWebView]. No-ops when the item carries no usable web url.
Future<void> showNewsItemWebView(BuildContext context, NewsItem item, {String? userId}) async {
  final uri = newsWebViewUri(item.webViewUrl, userId: userId);
  if (uri == null) {
    return;
  }
  await openInAppWebView(
    context,
    uri: uri,
    source: RedirectSource.newsCenter,
    // No title: the toolbar tracks the loaded page's own title. The content is
    // English-only, so it is forced left-to-right like the rest of the feature.
    builder: (_) => InAppWebViewScreen(uri: uri, textDirection: TextDirection.ltr),
  );
}
