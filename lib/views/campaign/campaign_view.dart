import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
//import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class CampaignWebViewScreen extends StatefulWidget {
  const CampaignWebViewScreen({super.key});

  @override
  State<CampaignWebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<CampaignWebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            if (_isAllowedDomain(uri)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..addJavaScriptChannel('CampaignBridge', onMessageReceived: _onJsMessage)
      ..loadRequest(Uri.parse('https://www.mysteriumvpn.com/features'));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    ),
  );

  bool _isAllowedDomain(Uri uri) {
    final host = uri.host;
    return host.endsWith('mysterium.network') || host.endsWith('mysteriumvpn.com');
  }

  void _onJsMessage(JavaScriptMessage message) {

  }
}
