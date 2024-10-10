import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor(this.ref);

  final Ref ref;
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorizedError(err)) {
      ref.invalidate(invalidateExpiredToken);
    }
    handler.next(err);
  }
}

bool _isUnauthorizedError(DioException err) {
  if (err.response?.statusCode == 401) {
    return true;
  }
  final data = err.response?.data;
  if (data is Map<String, dynamic> && data.containsKey('status') && data['status'] == 401) {
    return true;
  }
  return false;
}
