import 'package:mysterium_vpn/models/models.dart';

mixin ExternalApiService {
  Future<IPInfo?> getIPInfo();
  Future<String?> getIPAddress();
}
