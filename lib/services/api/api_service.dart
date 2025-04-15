import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<VPNLocations> fetchVPNLocations([IPType? ipType]);
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<void> setUserPrefsMarketingConsent({required bool consent});
  Future<bool> getUserPrefsMarketingConsent();
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
}
