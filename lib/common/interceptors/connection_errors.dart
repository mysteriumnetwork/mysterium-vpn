import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';

class ConnectionErrorsInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityStatus = await Connectivity().checkConnectivity();
    if (!connectivityStatus.hasConnectivity) {
      final endpoint = options.path;
      return handler.reject(
        ApiException(
          options,
          'Internet connection unavailable. Please verify your network settings and retry.',
          code: 0,
          identifier: 'No internet connection \nat  $endpoint',
          endpoint: endpoint,
          severity: ExceptionSeverity.low,
        ),
      );
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError) {
      final endpoint = err.requestOptions.path;
      return handler.reject(
        ApiException(
          err.requestOptions,
          'Unable to connect to the server. Please check your internet connection and try again.',
          code: 1,
          identifier: 'Socket Exception ${err.message} \nat  $endpoint',
          endpoint: endpoint,
          severity: ExceptionSeverity.low,
        ),
      );
    }

    handler.next(err);
  }
}
