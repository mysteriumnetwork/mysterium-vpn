import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class ApiErrorsInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final endpoint = err.requestOptions.path;

    if (err.response?.data != null && err.response?.data is Map<String, dynamic>) {
      final data = err.response?.data as Map<String, dynamic>;

      String? errorBodyCode;
      var errorCode = err.response?.statusCode ?? 500;
      if (data.containsKey('error') &&
          data['error'] is Map &&
          (data['error'] as Map).containsKey('code')) {
        errorBodyCode =
            // ignore: avoid_dynamic_calls
            data['error']['code'].toString();
        errorCode = int.tryParse(errorBodyCode) ?? errorCode;
      }

      var message = '';
      if (errorCode == 4029 || errorCode == 429) {
        message = LocaleKeys.toManyRequestsErrorMsg.tr();
      } else if (errorCode == 503) {
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
          code: errorCode,
          identifier: 'Dio Exception ${err.message} \nat  $endpoint',
          endpoint: endpoint,
          severity: errorCode >= 500 ? ExceptionSeverity.high : ExceptionSeverity.medium,
          errorCode: errorBodyCode,
        ),
      );
    }

    return handler.reject(
      ApiException(
        err.requestOptions,
        err.message ?? LocaleKeys.somethingWentWrong.tr(),
        code: err.response?.statusCode ?? 500,
        identifier: 'Dio Exception ${err.message} \nat  $endpoint',
        endpoint: endpoint,
        severity: ExceptionSeverity.high,
      ),
    );
  }
}
