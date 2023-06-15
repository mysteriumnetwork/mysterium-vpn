import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor(this.authStore);

  final AuthStore authStore;
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorizedError(err) && authStore.authStatus == AuthStatus.authenticated) {
      await authStore.logout();
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
