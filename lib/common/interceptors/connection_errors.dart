import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

class ConnectionErrorsInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityStatus = (await Connectivity().checkConnectivity()).lastOrNull;
    if (connectivityStatus == ConnectivityResult.none && !(await hasNetwork())) {
      final endpoint = options.path;
      return handler.reject(
        ApiException(
          options,
          'Internet connection unavailable. Please verify your network settings and retry.',
          0,
          'No internet connection \nat  $endpoint',
        ),
      );
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError) {
      final endpoint = err.requestOptions.path;
      return handler.reject(
        ApiException(
          err.requestOptions,
          'Unable to connect to the server. Please check your internet connection and try again.',
          0,
          'Socket Exception ${err.message} \nat  $endpoint',
        ),
      );
    }

    handler.next(err);
  }
}
