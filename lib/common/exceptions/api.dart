import 'package:dio/dio.dart';

class ApiException extends DioException {
  ApiException(
    RequestOptions requestOptions,
    String message, {
    required this.code,
    required this.identifier,
    required this.endpoint,
  }) : super(requestOptions: requestOptions, message: message);
  @override
  String get message => super.message!;
  String identifier;
  final int code;
  final String endpoint;
}
