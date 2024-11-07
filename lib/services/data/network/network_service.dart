import 'package:mysterium_vpn/models/response.dart';
import 'package:mysterium_vpn/models/token_request.dart';
import 'package:mysterium_vpn/models/token_response.dart';

// TODO(Waldz): Generate API client from API documentation openapi.yaml
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

  Future<TokenResponse> token(TokenRequest request) async {
    final response = await post(
      '/oauth/token',
      data: request.toJson(),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    return TokenResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
