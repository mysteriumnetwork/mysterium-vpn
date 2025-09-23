import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<WireguardConnectResponse> fetchWireguardVpnConfig({
    required WireguardConnectRequest request,
  });
  Future<OpenVpnConnectResponse> fetchOpenVpnConfig({
    required OpenVpnConnectRequest request,
  });
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
  Future<void> rateConnection({required RateConnectionRequest request});
  Future<void> createMarketingContact({required String? country});
  Future<void> updateMarketingContact({required bool consent});
  Future<bool> getMarketingContactStatus();
  Future<void> disconnect({required String publicKey});
  Future<Set<UserIntent>> fetchUserIntents();
}
