import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/report_broken_node_request.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class ApiService {
  Future<void> setNotificationsApproval({required bool approval});
  Future<Approval> getNotificationsApproval();
  Future<VPNLocations> fetchVPNLocations({required String keyword});
  Future<void> addRecentLocation(VPNLocation location);
  Future<List<VPNLocation>> getRecentLocations({required String keyword});
  Future<WireguardConnectResponse> fetchVpnConfig({required WireguardConnectRequest request});
  Future<IPInfo?> getIPAdress();
  Future<void> reportBrokenNode({required ReportBrokenNodeRequest request});
  Future<void> setUserPrefsMarketingConsent({required bool consent});
  Future<bool> getUserPrefsMarketingConsent();
  Future<List<BannerType>> getShownBanners();
  Future<void> setShownBanners(List<BannerType> banners);
  Future<void> disconnectAllDevices();
}
