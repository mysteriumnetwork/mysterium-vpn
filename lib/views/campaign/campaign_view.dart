import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
//import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

Future<void> showCampaignDialog(BuildContext context, Uri campaignUri, String? couponCode) async {
  await showModal<void>(
    context,
    builder: (_) => Theme(
      data: DesignSystemTheme.of(context),
      child: CampaignWebViewScreen(campaignUri: campaignUri, couponCode: couponCode),
    ),
  );
}

class CampaignWebViewScreen extends StatefulHookConsumerWidget {
  const CampaignWebViewScreen({required this.campaignUri, this.couponCode, super.key});

  final Uri campaignUri;
  final String? couponCode;

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
      ..loadRequest(widget.campaignUri);
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

  void _onJsMessage(JavaScriptMessage jsMessage) {
    final message = _Message.fromJson(jsonDecode(jsMessage.message) as Map<String, dynamic>);
    switch (message.type) {
      case _MessageType.subscribe:
        final _ = _SubscribePayload.fromJson(message.payload ?? {});
        _handleSubscribe();
        break;
      case _MessageType.subscriptionUpgrade:
        showSubscriptionUpgradeModalPage(context);
        break;
      case _MessageType.unknown:
        throw Exception('Unknown message type: ${message.type}');
    }
  }
}

enum _MessageType {
  subscribe,
  subscriptionUpgrade,
  unknown;

  static _MessageType fromString(String? raw) {
    if (raw == null) {
      return _MessageType.unknown;
    }
    switch (raw) {
      case 'subscribe':
        return _MessageType.subscribe;
      case 'subscription_upgrade':
        return _MessageType.subscriptionUpgrade;
      default:
        return _MessageType.unknown;
    }
  }
}

class _Message {
  _Message({required this.type, required this.payload});

  factory _Message.fromJson(Map<String, dynamic> json) => _Message(
    type: _MessageType.fromString(json['type'] as String?),
    payload: json['payload'] as Map<String, dynamic>?,
  );

  final _MessageType type;
  final Map<String, dynamic>? payload;
}

class _SubscribePayload {
  _SubscribePayload({required this.planId, required this.couponCode});

  factory _SubscribePayload.fromJson(Map<String, dynamic> json) => _SubscribePayload(
    planId: json['planId'] as String? ?? '',
    couponCode: json['couponCode'] as String? ?? '',
  );

  final String planId;
  final String couponCode;
}
