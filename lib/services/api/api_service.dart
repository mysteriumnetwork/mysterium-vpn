import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';

abstract class ApiService {
  Future<void> setEmailCommunicationApproval({required bool approval});
  Future<void> setNotificationsApproval({required bool approval});
  Approval geNotificationsApproval();
  Approval getEmailCommunicationApproval();
  Future<List<Location>> fetchAllLocations({required String keyword});
  Future<List<Location>> fetchTopLocations({required String keyword});
  Future<void> setRecentLocation({required String location});
  List<Location> getRecentLocations({required String keyword});
  Future<VpnConfig> fetchVpnConfig({required VpnConfigInput input, required String privateKey});
}
