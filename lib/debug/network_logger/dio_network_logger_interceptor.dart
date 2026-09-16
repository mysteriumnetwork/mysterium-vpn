import 'package:dio/dio.dart' as dio;
import 'package:mysterium_vpn/debug/network_logger/network_logger_events.dart';

extension DioNetworkLoggerX on dio.Dio {
  void addNetworkLogger() {
    interceptors.add(DioNetworkLoggerInterceptor());
  }
}

class DioNetworkLoggerInterceptor extends dio.Interceptor {
  DioNetworkLoggerInterceptor({NetworkEventList? eventList})
    : eventList = eventList ?? DioNetworkLogger.instance;
  final NetworkEventList eventList;
  final _requests = <dio.RequestOptions, NetworkEvent>{};

  @override
  Future<void> onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    eventList.add(_requests[options] = NetworkEvent(request: options.toRequest()));
  }

  @override
  void onResponse(dio.Response<dynamic> response, dio.ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    final event = _requests.remove(response.requestOptions);
    if (event != null) {
      event.completed(res: response.toResponse());

      eventList.updated(event);
    }
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    DioNetworkLogger.onError?.call(err);
    final event = _requests.remove(err.requestOptions);
    if (event != null) {
      eventList.updated(
        event..completed(err: err.toNetworkError(), res: err.response?.toResponse()),
      );
    }
  }
}

extension _RequestOptionsX on dio.RequestOptions {
  Request toRequest() => Request(
    uri: uri.toString(),
    data: data,
    method: method,
    headers: Headers(headers.entries.map((kv) => MapEntry(kv.key, '${kv.value}'))),
  );
}

extension _ResponseX on dio.Response<dynamic> {
  Response toResponse() => Response(
    data: data,
    statusCode: statusCode ?? -1,
    statusMessage: statusMessage ?? 'unkown',
    headers: Headers(
      headers.map.entries.fold<List<MapEntry<String, String>>>(
        [],
        (p, e) => p..addAll(e.value.map((v) => MapEntry(e.key, v))),
      ),
    ),
  );
}

extension _DioErrorX on dio.DioException {
  NetworkError toNetworkError() => NetworkError(message: toString());
}
