import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/report_broken_node_request.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';

abstract class ApiService {
  Future<void> setEmailCommunicationApproval({required bool approval});
  Future<void> setNotificationsApproval({required bool approval});
  Approval geNotificationsApproval();
  Approval getEmailCommunicationApproval();
  Future<VPNLocations> fetchVPNLocations({required String keyword});
  void addRecentLocation(String location);
  List<String> getRecentLocations({required String keyword});
  Future<VpnConfig> fetchVpnConfig({
    required VpnConfigInput input,
    required String privateKey,
    required String? replaceDNSAddress,
  });
  Future<IPInfo?> getIPAdress();
  Future<void> reportBrokenNode({required ReportBrokenNodeRequest request});
  Future<void> setUserPrefsMarketingConsent({required bool consent});
  Future<bool> getUserPrefsMarketingConsent();
  Future<void> setEmailMarketingConsent({required bool consent});
}
