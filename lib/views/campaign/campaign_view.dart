import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
//import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

part 'campaign_view.freezed.dart';
part 'campaign_view.g.dart';

Future<void> showCampaignDialog(BuildContext context, Uri campaignUri, String? couponCode) async {
  await showModal<void>(
    context,
    builder: (_) => Theme(
      data: DesignSystemTheme.of(context),
      child: CampaignWebViewScreen(campaignUri: campaignUri, couponCode: couponCode),
    ),
  );
}

class CampaignWebViewScreen extends HookConsumerWidget {
  const CampaignWebViewScreen({required this.campaignUri, this.couponCode, super.key});

  final Uri campaignUri;
  final String? couponCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final isLoading = useState(true);
    final handleSubscribe = useHandleSubscribe();

    final controller =
        useMemoized(() {
            final controller = WebViewController();

            controller
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageFinished: (_) => isLoading.value = false,
                  onNavigationRequest: (request) {
                    final uri = Uri.parse(request.url);
                    if (_isAllowedDomain(uri)) {
                      return NavigationDecision.navigate;
                    }
                    return NavigationDecision.prevent;
                  },
                ),
              )
              ..addJavaScriptChannel(
                'CampaignBridge',
                onMessageReceived: (msg) =>
                    _onJsMessage(msg, context, controller, subscriptionStore, handleSubscribe),
              );
            return controller;
          })
          // For debugging purposes turn this on
          /*
    ..setOnJavaScriptAlertDialog((request) async {
      print('==ALERT ${request.message}');
      return;
    });
    */
          ..loadRequest(campaignUri);

    return ModalScaffold(
      autoApplyPadding: false,
      showGradient: false,
      showCloseButton: false,
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading.value) const Center(child: CircularProgressIndicator()),
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

  void _onJsMessage(
    JavaScriptMessage jsMessage,
    BuildContext context,
    WebViewController controller,
    SubscriptionStore subscriptionStore,
    FutureOr<void> Function({bool manageSubscription}) handleSubscribe,
  ) async {
    final message = _Message.fromJson(jsonDecode(jsMessage.message) as Map<String, dynamic>);
    switch (message.type) {
      case _MessageType.orderSummary:
        final request = _OrderSummaryRequest.fromJson(message.payload ?? {});
        final orderSummary = await subscriptionStore.calculateOrderBreakdown(
          planId: request.planId,
          country: request.country,
          couponCode: request.couponCode,
        );

        final response = _Message(
          type: _MessageType.orderSummary,
          requestId: message.requestId,
          payload: _OrderSummaryResponse(
            orderTotal: orderSummary.orderTotal,
            couponError: orderSummary.couponError,
          ).toJson(),
        );
        await controller.runJavaScript(
          'window.onCampaignBridgeMessage(${jsonEncode(response.toJson())});',
        );

      case _MessageType.subscribe:
        final _ = _SubscribePayload.fromJson(message.payload ?? {});
        handleSubscribe();
        break;

      case _MessageType.subscriptionUpgrade:
        showSubscriptionUpgradeModalPage(context);
        break;

      case _MessageType.unknown:
        throw Exception('Unknown message type: ${message.type}');
    }
  }
}

@JsonEnum(alwaysCreate: true)
enum _MessageType {
  @JsonValue('order_summary')
  orderSummary,
  @JsonValue('subscribe')
  subscribe,
  @JsonValue('subscription_upgrade')
  subscriptionUpgrade,
  @JsonValue('unknown')
  unknown,
}

@freezed
abstract class _Message with _$Message {
  const factory _Message({
    @JsonKey(name: 'type') required _MessageType type,
    @JsonKey(name: 'requestId') String? requestId,
    @JsonKey(name: 'payload') Map<String, dynamic>? payload,
  }) = _MessageData;

  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

@freezed
abstract class _OrderSummaryRequest with _$OrderSummaryRequest {
  factory _OrderSummaryRequest({
    @JsonKey(name: 'planId') required String planId,
    @JsonKey(name: 'country') required String country,
    @JsonKey(name: 'state') required String? state,
    @JsonKey(name: 'couponCode') required String? couponCode,
  }) = _OrderSummaryRequestData;

  factory _OrderSummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryRequestFromJson(json);
}

@freezed
abstract class _OrderSummaryResponse with _$OrderSummaryResponse {
  factory _OrderSummaryResponse({
    @JsonKey(name: 'orderTotal') required String orderTotal,
    @JsonKey(name: 'couponError') required String? couponError,
  }) = _OrderSummaryResponseData;

  factory _OrderSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryResponseFromJson(json);
}

@freezed
abstract class _SubscribePayload with _$SubscribePayload {
  factory _SubscribePayload({
    @JsonKey(name: 'planId') required String planId,
    @JsonKey(name: 'couponCode') required String? couponCode,
  }) = _SubscribePayloadData;

  factory _SubscribePayload.fromJson(Map<String, dynamic> json) => _$SubscribePayloadFromJson(json);
}
