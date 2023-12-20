import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/user_data.dart';

class LocalDBService {
  LocalDBService();

  String? _userId;

  UserData userData = UserData(
    userId: '',
    recentLocations: [],
  );

  Future<void> setUserId(String userId) async {
    _userId = userId;
    if (checkUserExistance(userId)) {
      userData = box.get(userId)!;
    } else {
      await _setInitUserData(userId);
      userData = box.get(userId)!;
    }
  }

  final box = Hive.box<UserData>('user_data');

  bool checkUserExistance(String key) => box.containsKey(key);

  Future<void> setEmailCommunicationApproval({required bool approval}) async {
    userData.emailCommunication = approval ? Approval.approved : Approval.declined;
    await box.put(_userId, userData);
  }

  Future<void> setNotificationsApproval({required bool approval}) async {
    userData.notifications = approval ? Approval.approved : Approval.declined;
    await box.put(_userId, userData);
  }

  Future<void> setVpnConsentApproval({required bool approval}) async {
    userData.vpnConfigConsent = approval;
    await box.put(_userId, userData);
  }

  bool getResetConnection() => userData.resetConnection;

  Future<void> setResetConnection({required bool resetConnection}) async {
    userData.resetConnection = resetConnection;
    await box.put(_userId, userData);
  }

  bool? getVpnConsentApproval() => userData.vpnConfigConsent;

  Approval getNotificationsApproval() => userData.notifications;

  Approval getEmailCommunicationApproval() => userData.emailCommunication;

  Future<void> setRecentLocation(List<String> locations) async {
    userData.recentLocations = locations;
    await box.put(_userId, userData);
  }

  Future<void> setSubscriptionPurchase({
    required String subscriptionPlan,
    required String subscriptionPurchaseId,
  }) async {
    userData
      ..subscriptionPlan = subscriptionPlan
      ..subscriptionPurchaseId = subscriptionPurchaseId;
    await box.put(_userId, userData);
  }

  Future<void> setSubscriptionPlan(
    String subscriptionPlan,
  ) async {
    userData.subscriptionPlan = subscriptionPlan;
    await box.put(_userId, userData);
  }

  List<String> getRecentLocations() => userData.recentLocations;

  String? getSubscriptionPlan() => userData.subscriptionPlan;

  String? getSubscriptionPurchaseId() => userData.subscriptionPurchaseId;

  Future<void> _setInitUserData(
    String key,
  ) async {
    await box.put(
      key,
      UserData(
        userId: key,
        recentLocations: [],
      ),
    );
  }
}
