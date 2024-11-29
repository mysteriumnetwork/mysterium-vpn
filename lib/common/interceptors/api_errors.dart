import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class ApiErrorsInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final endpoint = err.requestOptions.path;

    if (err.response?.data != null && err.response?.data is Map<String, dynamic>) {
      final data = err.response?.data as Map<String, dynamic>;

      var errorCode = err.response?.statusCode ?? 500;
      if (data.containsKey('error') &&
          data['error'] is Map &&
          (data['error'] as Map).containsKey('code')) {
        errorCode =
            // ignore: avoid_dynamic_calls
            int.tryParse(data['error']['code'].toString()) ?? errorCode;
      }

      var message = '';
      if (err.response?.statusCode == 503) {
        message = err.message ?? LocaleKeys.serviceUnavailableError.tr();
      } else if (data.containsKey('status') && data['status'] == 503) {
        message = err.message ?? LocaleKeys.serviceUnavailableError.tr();
      } else if (!data.containsKey('error')) {
        message = err.message ?? LocaleKeys.somethingWentWrong.tr();
      } else if (data['error'] is Map<String, dynamic> &&
          (data['error'] as Map<String, dynamic>).containsKey('message')) {
        // ignore: avoid_dynamic_calls
        message = data['error']['message'] as String? ?? LocaleKeys.somethingWentWrong.tr();
      } else {
        message = err.message ?? LocaleKeys.somethingWentWrong.tr();
      }
      return handler.reject(
        ApiException(
          err.requestOptions,
          message,
          errorCode,
          'Dio Exception ${err.message} \nat  $endpoint',
        ),
      );
    }

    return handler.reject(
      ApiException(
        err.requestOptions,
        LocaleKeys.somethingWentWrong.tr(),
        500,
        'Dio Exception ${err.message} \nat  $endpoint',
      ),
    );
  }
}
