import 'package:dio/dio.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';

class TestFlagsInterceptor extends InterceptorsWrapper {
  TestFlagsInterceptor(this.environment);

  final FlavorConfig environment;
}
