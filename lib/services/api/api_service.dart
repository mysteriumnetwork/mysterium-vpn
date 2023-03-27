import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';

abstract class ApiService {
  Future<void> setEmailCommunicationApproval({required bool approval});
  Future<void> setNotificationsApproval({required bool approval});
  Approval geNotificationsApproval();
  Approval getEmailCommunicationApproval();
  Future<List<Location>> fetchAllLocations({required String keyword});
  Future<List<Location>> fetchTopLocations({required String keyword});
  Future<void> setRecentLocation({required String location});
  Future<List<Location>> getRecentLocations({required String keyword});
}
