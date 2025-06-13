import 'package:dio/dio.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';

class TestFlagsInterceptor extends InterceptorsWrapper {
  TestFlagsInterceptor(this.environment);

  final FlavorConfig environment;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.endsWith('/magic-link')) {
      // if the request is for magic link, add quick_auth query parameter to request
      return handler.next(
        options
          ..queryParameters = {
            ...options.queryParameters,
            'quick_auth': environment.values.quickAuth,
          },
      );
    }

    super.onRequest(options, handler);
  }
}
