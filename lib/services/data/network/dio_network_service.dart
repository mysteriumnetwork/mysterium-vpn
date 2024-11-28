import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/mixins/exception_handler_mixin.dart';
import 'package:mysterium_vpn/models/response.dart' as response;
import 'package:mysterium_vpn/services/data/network/network_service.dart';

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  DioNetworkService(
    this.dio,
  );
  final Dio dio;

  @override
  Future<response.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    final res = await handleException(
          () => dio.post(
        endpoint,
        data: data,
        cancelToken: CancelToken(),
        options: Options(
          headers: {...dio.options.headers, if (headers != null) ...headers},
        ),
      ),
      endpoint: endpoint,
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
    final res = await handleException(
          () => dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {...dio.options.headers, if (headers != null) ...headers},
        ),
        cancelToken: CancelToken(),
      ),
      endpoint: endpoint,
    );

    return response.Response(
      statusCode: res.statusCode ?? 200,
      data: res.data,
      statusMessage: res.statusMessage,
    );
  }

  @override
  Future<response.Response> fetch(String url) async {
    final res = await handleException(
          () => dio.fetch(
        RequestOptions(
          baseUrl: url,
          cancelToken: CancelToken(),
        ),
      ),
    );

    return response.Response(
      statusCode: res.statusCode ?? 200,
      data: res.data,
      statusMessage: res.statusMessage,
    );
  }
}
