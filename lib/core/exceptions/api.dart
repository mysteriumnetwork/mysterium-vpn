import 'package:dio/dio.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';

class ApiException extends DioException {
  ApiException(
    RequestOptions requestOptions,
    String message, {
    required this.code,
    required this.identifier,
    required this.endpoint,
    required this.severity,
    this.errorCode,
  }) : super(requestOptions: requestOptions, message: message);
  @override
  String get message => super.message!;
  String identifier;
  final int code;
  final String endpoint;
  final ExceptionSeverity severity;
  final String? errorCode;

  @override
  String toString() => '$message [code: $code]';
}
