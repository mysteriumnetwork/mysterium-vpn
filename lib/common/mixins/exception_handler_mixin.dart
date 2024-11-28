import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/data/network/network_service.dart';

mixin ExceptionHandlerMixin on NetworkService {
  Future<Response<dynamic>> handleException(
    Future<Response<dynamic>> Function() handler, {
    String endpoint = '',
  }) async {
    try {
      return await handler();
    } catch (e) {
      var message = '';
      var identifier = '';
      var statusCode = 0;
      switch (e) {
        case DioException _:
          if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
            identifier = 'Dio Exception ${e.message} \nat  $endpoint';
            final data = e.response?.data as Map<String, dynamic>;
            statusCode = e.response?.statusCode ?? 500;
            if (data.containsKey('error') &&
                data['error'] is Map &&
                (data['error'] as Map).containsKey('code')) {
              statusCode =
                  // ignore: avoid_dynamic_calls
                  int.tryParse(data['error']['code'].toString()) ?? statusCode;
            }
            if (e.response?.statusCode == 503) {
              message = e.message ?? LocaleKeys.serviceUnavailableError.tr();
            } else if (data.containsKey('status') && data['status'] == 503) {
              message = e.message ?? LocaleKeys.serviceUnavailableError.tr();
            } else if (!data.containsKey('error')) {
              message = e.message ?? LocaleKeys.somethingWentWrong.tr();
            } else if (data['error'] is Map<String, dynamic> &&
                (data['error'] as Map<String, dynamic>).containsKey('message')) {
              // ignore: avoid_dynamic_calls
              message = data['error']['message'] as String? ?? LocaleKeys.somethingWentWrong.tr();
            } else {
              message = e.message ?? LocaleKeys.somethingWentWrong.tr();
            }
          } else {
            message = LocaleKeys.somethingWentWrong.tr();
            statusCode = 500;
            identifier = 'Dio Exception ${e.message} \nat  $endpoint';
          }
          throw ApiException(RequestOptions(), message, statusCode, identifier);

        default:
          message = 'Unknown error occurred';
          statusCode = 2;
          identifier = 'Unknown error $e\n at $endpoint';
          throw ApiException(RequestOptions(), message, statusCode, identifier);
      }
    }
  }
}
