import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
  Future<void> rateConnection({required RateConnectionRequest request});
  Future<void> createMarketingContact({required String? country});
  Future<void> updateMarketingContact({required bool consent});
  Future<bool> getMarketingContactStatus();
  Future<void> disconnect();
  Future<Set<UserIntent>> fetchUserIntents();
}
