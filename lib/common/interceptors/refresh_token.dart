import 'dart:async';

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

Future<void> Function()? refreshTokenCallback;

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({required this.dio, required this.logger});

  final Dio dio;
  final Talker logger;

  Future<void>? _refreshFuture;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_isUnauthorizedError(err)) {
      return handler.next(err);
    }
    final requestData = err.requestOptions.data;
    if (requestData is Map<String, dynamic> && requestData['grant_type'] == 'refresh_token') {
      logger.handle(err, err.stackTrace, 'Failed to refresh authorization');
      return handler.next(err);
    }

    try {
      if (_refreshFuture == null && refreshTokenCallback == null) {
        logger.handle(
          err,
          err.stackTrace,
          'Unable to refresh authorization: refreshTokenCallback is not set',
        );
        return handler.next(err);
      }
      _refreshFuture ??= refreshTokenCallback!.call();
      await _refreshFuture;
      _refreshFuture = null;
    } catch (e, stackTrace) {
      _refreshFuture = null;
      logger.handle(e, stackTrace, 'Failed to refresh expired authorization');
      return handler.next(err);
    }

    // Retry the request.
    try {
      return handler.resolve(await _retry(err.requestOptions));
    } on DioException catch (e) {
      // If the request fails again, pass the error to the next interceptor in the chain.
      return handler.next(e);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
    final options = Options(method: requestOptions.method, headers: {'Retry': 'Yes'});

    // Retry the request with the new `RequestOptions` object.
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
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
}
