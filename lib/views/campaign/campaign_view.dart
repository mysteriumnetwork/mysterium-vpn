import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
//import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

Future<void> showCampaignDialog(BuildContext context) async {
  await showModal<void>(
    context,
    builder: (_) =>
        Theme(data: DesignSystemTheme.of(context), child: const CampaignWebViewScreen()),
  );
}

class CampaignWebViewScreen extends StatefulHookConsumerWidget {
  const CampaignWebViewScreen({super.key});

  @override
  ConsumerState<CampaignWebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<CampaignWebViewScreen> {
  late WebViewController _controller;
  late FutureOr<void> Function({bool manageSubscription}) _handleSubscribe;

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
      //..loadRequest(Uri.parse('https://www.mysteriumvpn.com/features'))
      ..loadRequest(Uri.parse('http://localhost:3000/campaign'));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _handleSubscribe = useHandleSubscribe();

    return ModalScaffold(
      autoApplyPadding: false,
      showGradient: false,
      showCloseButton: false,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  bool _isAllowedDomain(Uri uri) {
    final host = uri.host;
    return host.endsWith('mysterium.network') ||
        host.endsWith('mysteriumvpn.com') ||
        host.endsWith('localhost');
  }

  void _onJsMessage(JavaScriptMessage message) {
    final data = jsonDecode(message.message) as Map<String, dynamic>;
    final type = data['type'] as String?;

    switch (type) {
      case 'DEBUG_PING':
        break;
      case 'SUBSCRIBE':
        _handleSubscribe();
        break;
      case 'DISCOUNT_VALIDATE':
        //_handleDiscountValidate(data['payload'] as Map<String, dynamic>?);
        break;
      case 'OPEN_INTERCOM':
        //_handleOpenIntercom(data['payload'] as Map<String, dynamic>?);
        break;
      case 'CLOSE_LS':
        //_handleClose();
        break;
      default:
        break;
    }
  }
}
