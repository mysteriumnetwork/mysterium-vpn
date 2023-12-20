import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/mixins/exception_handler_mixin.dart';
import 'package:mysterium_vpn/models/response.dart' as response;
import 'package:mysterium_vpn/services/data/network/network_service.dart';

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  DioNetworkService(this.dio, this.interceptors, this.baseUrl) {
    dio.options = dioBaseOptions;

    dio.interceptors.addAll(interceptors);
  }
  final Dio dio;
  final List<Interceptor> interceptors;
  final String baseUrl;

  BaseOptions get dioBaseOptions => BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      );

  @override
  Map<String, Object> get headers => {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      };

  @override
  void updateHeader(Map<String, dynamic> data) => dio.options.headers = {...data, ...headers};

  @override
  Future<response.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await handleException(
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<response.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await handleException(
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<response.Response> fetch(String url) async {
    try {
      return await handleException(
        () => dio.fetch(
          RequestOptions(
            baseUrl: url,
            cancelToken: CancelToken(),
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
