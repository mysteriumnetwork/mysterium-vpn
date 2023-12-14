import 'package:mysterium_vpn/models/response.dart';

abstract class NetworkService {
  Map<String, Object> get headers;

  void updateHeader(Map<String, dynamic> data);

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  });

  Future<Response> fetch(
    String url,
  );
}
