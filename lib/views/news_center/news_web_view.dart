import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens a News Center item's content in an in-app webview modal (via
/// [showModal] — this is a dialog, not a route).
Future<void> showNewsWebView(BuildContext context, Uri uri) async {
  await showModal<void>(context, builder: (_) => _NewsWebViewScreen(uri: uri));
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
    // `ModalScaffold`'s app bar strips the top `padding` from the body, so a
    // `SafeArea` here sees a zero inset and the bar rides up under the status
    // bar. `viewPadding` keeps the real inset, so pad by it directly.
    final topInset = MediaQuery.viewPaddingOf(context).top;
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
