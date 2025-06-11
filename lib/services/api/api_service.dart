import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
  Future<void> rateConnection({required RateConnectionRequest request});
  Future<void> setMarketingConsentStatus({required bool consent});
  Future<void> disconnect({required String publicKey});
}
