import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';

class LocalDBService {
  LocalDBService();

  String? _userId;

  UserData userData = UserData(
    userId: '',
    recentLocations: [],
  );

  Future<void> setUserId(AuthUser user) async {
    _userId = user.userId;
    userData = await _loadUserData(user);
  }

  final box = Hive.box<UserData>('user_data');

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

  bool getRefreshIPConnection() => userData.refreshIPConnection;

  Future<void> setRefreshIPConnection({required bool refreshIPConnection}) async {
    userData.refreshIPConnection = refreshIPConnection;
    await box.put(_userId, userData);
  }

  bool getMalwareBlocker() => userData.malwareBlocker;

  Future<void> setMalwareBlocker({required bool malwareBlocker}) async {
    userData.malwareBlocker = malwareBlocker;
    await box.put(_userId, userData);
  }

  bool getNotSafeContentBlocker() => userData.notSafeContentBlocker;

  Future<void> setNotSafeContentBlocker({required bool notSafeContentBlocker}) async {
    userData.notSafeContentBlocker = notSafeContentBlocker;
    await box.put(_userId, userData);
  }

  Future<bool?> getVpnConsentApproval(AuthUser user) async =>
      (await _loadUserData(user)).vpnConfigConsent;

  Approval getNotificationsApproval() => userData.notifications;

  Approval getEmailCommunicationApproval() => userData.emailCommunication;

  Future<void> setRecentLocation(List<String> locations) async {
    userData.recentLocations = locations;
    await box.put(_userId, userData);
  }

  List<String> getRecentLocations() => userData.recentLocations;

  Future<UserData> _loadUserData(AuthUser user) async {
    final cacheId = user.username;
    if (!box.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return box.get(cacheId)!;
  }

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
