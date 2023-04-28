import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor(this.authStore);

  final AuthStore authStore;
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode == 401 ||
            (err.response?.data as Map<String, dynamic>?)?['status'] == 401) &&
        authStore.authStatus == AuthStatus.authenticated) {
      await authStore.logout();
    }
  }
}
