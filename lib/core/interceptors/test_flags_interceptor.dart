import 'package:dio/dio.dart';

class TestFlagsInterceptor extends InterceptorsWrapper {
  TestFlagsInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.endsWith('/magic-link')) {
      // if the request is for magic link, add quick_auth query parameter to request
      return handler.next(
        options..queryParameters = {...options.queryParameters, 'quick_auth': true},
      );
    }

    super.onRequest(options, handler);
  }
}
