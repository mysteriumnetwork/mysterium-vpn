import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<void> setNotificationsApproval({required bool approval});
  Future<Approval> getNotificationsApproval();
  Future<VPNLocations> fetchVPNLocations([IPType? ipType]);
  Future<void> addRecentLocation(VPNLocation location);
  Future<List<VPNLocation>> getRecentLocations();
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<void> setUserPrefsMarketingConsent({required bool consent});
  Future<bool> getUserPrefsMarketingConsent();
  Future<List<BannerType>> getShownBanners();
  Future<void> setShownBanners(List<BannerType> banners);
  Future<void> disconnectAllDevices();
  Future<void> udpBlockedCheck();
}
