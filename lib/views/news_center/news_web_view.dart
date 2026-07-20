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
        // Only mount the WebView once the page has loaded — the native view
        // paints an opaque white surface while it initializes/loads, which
        // otherwise covers the spinner for the first 1-2s. The controller loads
        // the URL in the background regardless of whether the widget is mounted.
        body: isLoading.value
            ? const Center(child: LoadingIndicator())
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
