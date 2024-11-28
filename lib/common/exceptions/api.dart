import 'package:dio/dio.dart';

class ApiException extends DioException {
  ApiException(RequestOptions requestOptions, String message, this.code, this.identifier)
      : super(requestOptions: requestOptions, message: message);
  @override
  String get message => super.message!;
  String identifier;
  final int code;
}
