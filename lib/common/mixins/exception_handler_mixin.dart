import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/response.dart' as response;
import 'package:mysterium_vpn/services/data/network/network_service.dart';

mixin ExceptionHandlerMixin on NetworkService {
  Future<response.Response> handleException(
    Future<Response<dynamic>> Function() handler, {
    String endpoint = '',
  }) async {
    try {
      if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
        throw const SocketException('No internet connection');
      }
      final res = await handler();
      return response.Response(
        statusCode: res.statusCode ?? 200,
        data: res.data,
        statusMessage: res.statusMessage,
      );
    } catch (e) {
      var message = '';
      var identifier = '';
      var statusCode = 0;
      switch (e.runtimeType) {
        case SocketException:
          e as SocketException;
          message =
              'Internet connection unavailable. Please verify your network settings and retry.';
          statusCode = 0;
          identifier = 'Socket Exception ${e.message} \nat  $endpoint';
          break;

        case DioException:
          e as DioException;
          if (e.error is SocketException) {
            message =
                'Unable to connect to the server. Please check your internet connection and try again.';
            statusCode = 0;
            identifier = 'Socket Exception ${e.message} \nat  $endpoint';
          } else if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
            statusCode = e.response?.statusCode ?? 402;
            identifier = 'Dio Exception ${e.message} \nat  $endpoint';
            final data = e.response?.data as Map<String, dynamic>;

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
          break;

        default:
          message = 'Unknown error occurred';
          statusCode = 2;
          identifier = 'Unknown error $e\n at $endpoint';
      }
      throw ApiException(message, statusCode, identifier);
    }
  }
}
