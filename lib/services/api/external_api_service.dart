import 'package:mysterium_vpn/models/ip_info.dart';

mixin ExternalApiService {
  Future<IPInfo?> getIPInfo();
  Future<String?> getIPAddress();
}
