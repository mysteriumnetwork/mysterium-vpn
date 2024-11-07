import 'dart:async';

import 'package:dio/dio.dart';

typedef RefreshTokenCallback = Future<String> Function();

late final RefreshTokenCallback refreshTokenCallback;

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor();
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorizedError(err)) {
      try {
        if (!isRefreshing) {
          isRefreshing = true;
          // Initiating token refresh
          final authToken = await refreshTokenCallback();
          // Retrying failed requests
          retryRequests(authToken);
        } else {
          // Adding errored request to the queue
          failedRequests.add({'err': err, 'handler': handler});
        }
      } catch (e) {
        return handler.reject(err);
      }
    } else {
      return handler.next(err);
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

  Future<void> retryRequests(String authToken) async {
    final retryDio = Dio();
    for (var i = 0; i < failedRequests.length; i++) {
      final requestOptions = (failedRequests[i]['err'] as DioException).requestOptions;

      requestOptions.headers.addAll({'Authorization': 'Bearer $authToken'});

      await retryDio.fetch(requestOptions).then(
        (failedRequests[i]['handler'] as ErrorInterceptorHandler).resolve,
        onError: (error) async {
          (failedRequests[i]['handler'] as ErrorInterceptorHandler).reject(error as DioException);
        },
      );
    }
    isRefreshing = false;
    failedRequests = [];
  }
}
