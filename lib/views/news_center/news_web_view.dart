import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
Future<void> showNewsItemWebView(
  BuildContext context,
  NewscenterInboxListResponseItem item, {
  String? userId,
}) async {
  final uri = newsWebViewUri(item.webViewUrl, userId: userId);
  if (uri == null) {
    return;
  }
  await openInAppWebView(
    context,
    uri: uri,
    source: RedirectSource.newsCenter,
    builder: (_) => _NewsWebViewScreen(uri: uri),
  );
}

/// In-app webview modal with an opaque toolbar (page title + close) above a
/// webview that fills the space below it.
class _NewsWebViewScreen extends HookWidget {
  const _NewsWebViewScreen({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = useState(true);
    final title = useState('');

    final controller = useMemoized(() {
      final controller = WebViewController();
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        // The native surface is opaque white until the page paints, and it is
        // not masked to the modal's rounded corners; match the background so it
        // cannot flash white through them.
        ..setBackgroundColor(theme.palette.bgPopover)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) async {
              isLoading.value = false;
              // onPageFinished can fire per redirect; only rebuild on a change.
              final pageTitle = await controller.getTitle() ?? '';
              if (pageTitle != title.value) {
                title.value = pageTitle;
              }
            },
          ),
        )
        ..loadRequest(uri);
      return controller;
    });

    // English-only content, forced left-to-right like the rest of the feature.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ModalScaffold(
        autoApplyPadding: false,
        showGradient: false,
        // The toolbar below owns the close control; suppress the default app bar.
        appbar: const PreferredSize(preferredSize: Size.zero, child: SizedBox()),
        body: Column(
          children: [
            _WebViewBar(title: title.value, onClose: () => Navigator.of(context).pop()),
            Expanded(
              // Mounted immediately so the WebView initializes and
              // `onPageFinished` fires (an unmounted WebView never loads). The
              // overlay hides the surface the native view paints while it loads.
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading.value)
                    Positioned.fill(
                      child: ColoredBox(
                        color: theme.palette.bgPopover,
                        child: const Center(child: LoadingIndicator()),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opaque toolbar: the current page [title] and a fixed close button. Being a
/// solid, themed bar (not floating over content), the × is always legible and
/// reliably tappable.
class _WebViewBar extends StatelessWidget {
  const _WebViewBar({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // `ModalScaffold`'s app bar makes the inner Scaffold zero the body's
    // padding/viewPadding, so pull the status-bar inset from the view (as
    // `ModalAppbar`/`Header` do) rather than from MediaQuery here.
    final topInset = ScreenType.topSafeAreaInset(context);
    return Material(
      color: theme.palette.bgSidePanel,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(width: theme.spacing.xl),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.textMd.semibold.copyWith(
                    color: theme.palette.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(UntitledUI.x_close, color: theme.palette.iconPrimary),
                iconSize: 24,
                tooltip: newsWebViewCloseText,
              ),
              SizedBox(width: theme.spacing.s),
            ],
          ),
        ),
      ),
    );
  }
}
