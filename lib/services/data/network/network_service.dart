import 'package:mysterium_vpn/models/models.dart';

// TODO(Waldz): Generate API client from API documentation openapi.yaml
abstract class NetworkService {
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
