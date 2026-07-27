import 'package:dio/dio.dart';
import 'package:mysterium_vpn/models/models.dart' as response;
import 'package:mysterium_vpn/services/services.dart';

class DioNetworkService extends NetworkService {
  DioNetworkService(this.dio);
  final Dio dio;

  @override
  Future<response.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final res = await dio.post(
      endpoint,
      data: data,
      cancelToken: CancelToken(),
      options: Options(headers: {...dio.options.headers, ...?headers}),
    );

    return response.Response(
      statusCode: res.statusCode ?? 200,
      data: res.data,
      statusMessage: res.statusMessage,
    );
  }

  @override
  Future<response.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final res = await dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: {...dio.options.headers, ...?headers}),
      cancelToken: CancelToken(),
    );

    return response.Response(
      statusCode: res.statusCode ?? 200,
      data: res.data,
      statusMessage: res.statusMessage,
    );
  }

  @override
  Future<response.Response> fetch(String url) async {
    final res = await dio.fetch(RequestOptions(baseUrl: url, cancelToken: CancelToken()));

    return response.Response(
      statusCode: res.statusCode ?? 200,
      data: res.data,
      statusMessage: res.statusMessage,
    );
  }
}
