import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/api/rest_api_service.dart';
import 'package:mysterium_vpn/services/subscription/rest_subscription_service.dart';

List<String> _getAuthPaths() => [
      kFetchSubscriptionInfo,
      kCreateConnectionConfig,
      kVerifySubscription,
    ];

class AppendTokenInterceptor extends Interceptor {
  AppendTokenInterceptor(this.ref) {
    ref.listen(tokenStreamPOD, (_, value) {
      _token = value.valueOrNull;
      if (_token != null && !firstElementReceived.isCompleted) {
        firstElementReceived.complete();
      }
    });
  }

  String? _token;

  final Completer<void> firstElementReceived = Completer<void>();

  final Ref ref;
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_getAuthPaths().contains(options.path)) {
      await firstElementReceived.future;
      options.headers['Authorization'] = 'Bearer $_token';
    }

    return super.onRequest(options, handler);
  }
}
