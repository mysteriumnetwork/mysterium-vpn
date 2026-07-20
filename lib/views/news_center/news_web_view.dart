import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens a News Center item's content in an in-app webview modal (via
/// [showModal] — this is a dialog, not a route).
Future<void> showNewsWebView(BuildContext context, Uri uri) async {
  await showModal<void>(context, builder: (_) => _NewsWebViewScreen(uri: uri));
}

class _NewsWebViewScreen extends HookWidget {
  const _NewsWebViewScreen({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);

    final controller = useMemoized(() {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) => isLoading.value = false))
        ..loadRequest(uri);
      return controller;
    });

    // English-only content, forced left-to-right like the rest of the feature.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ModalScaffold(
        autoApplyPadding: false,
        showGradient: false,
        // Mount the WebView immediately so it initializes and `onPageFinished`
        // actually fires (an unmounted WebView never loads, which would leave
        // the spinner stuck forever). While it loads, an opaque overlay hides
        // the white surface the native view paints on init.
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading.value)
              Positioned.fill(
                child: ColoredBox(
                  color: Theme.of(context).palette.bgPopover,
                  child: const Center(child: LoadingIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
