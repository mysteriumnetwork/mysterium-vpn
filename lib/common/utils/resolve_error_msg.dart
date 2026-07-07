import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

String resolveErrorMessage(Object error) {
  if (error is DioException) {
    return error.message ?? S.current.somethingWentWrong;
  } else if (error is ApiException) {
    return error.message;
  } else if (error is Exception) {
    return error.toString();
  } else if (error is String) {
    return error;
  }
  return S.current.somethingWentWrong;
}
