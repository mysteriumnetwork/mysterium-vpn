import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<VPNLocations> fetchVPNLocations([IPType? ipType]);
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
  Future<void> rateConnection({required RateConnectionRequest request});
  Future<void> setMarketingConsentStatus({required bool consent});
}
