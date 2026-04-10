import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

String resolveErrorMessage(Object error) {
  if (error is DioException) {
    return error.message ?? LocaleKeys.somethingWentWrong.tr();
  } else if (error is ApiException) {
    return error.message;
  } else if (error is Exception) {
    return error.toString();
  } else if (error is String) {
    return error;
  }
  return LocaleKeys.somethingWentWrong.tr();
}
