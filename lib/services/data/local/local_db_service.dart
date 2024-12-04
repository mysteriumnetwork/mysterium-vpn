import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';

class LocalDBService {
  LocalDBService();

  final box = Hive.box<UserData>('user_data');

  Future<UserData> getUserData(AuthUser user) => _loadUserData(user);

  Future<void> setNotificationsApproval(AuthUser user, {required bool approval}) async {
    final userData = await _loadUserData(user);
    userData.notifications = approval ? Approval.approved : Approval.declined;

    await _saveUserData(user, userData);
  }

  Future<Approval> getNotificationsApproval(AuthUser user) async =>
      (await _loadUserData(user)).notifications;

  Future<void> setVpnConsentApproval(AuthUser user, {required bool approval}) async {
    final userData = await _loadUserData(user);
    userData.vpnConfigConsent = approval;

    await _saveUserData(user, userData);
  }

  Future<bool?> getVpnConsentApproval(AuthUser user) async =>
      (await _loadUserData(user)).vpnConfigConsent;

  Future<bool> getRefreshIPConnection(AuthUser user) async =>
      (await _loadUserData(user)).refreshIPConnection;

  Future<void> setRefreshIPConnection(AuthUser user, {required bool refreshIPConnection}) async {
    final userData = await _loadUserData(user);
    userData.refreshIPConnection = refreshIPConnection;

    await _saveUserData(user, userData);
  }

  Future<bool> getMalwareBlocker(AuthUser user) async => (await _loadUserData(user)).malwareBlocker;

  Future<void> setMalwareBlocker(AuthUser user, {required bool malwareBlocker}) async {
    final userData = await _loadUserData(user);
    userData.malwareBlocker = malwareBlocker;

    await _saveUserData(user, userData);
  }

  Future<bool> getNotSafeContentBlocker(AuthUser user) async =>
      (await _loadUserData(user)).notSafeContentBlocker;

  Future<void> setNotSafeContentBlocker(
    AuthUser user, {
    required bool notSafeContentBlocker,
  }) async {
    final userData = await _loadUserData(user);
    userData.notSafeContentBlocker = notSafeContentBlocker;

    await _saveUserData(user, userData);
  }

  Future<void> setRecentLocation(AuthUser user, List<String> locations) async {
    final userData = await _loadUserData(user);
    userData.recentLocations = locations;

    await _saveUserData(user, userData);
  }

  Future<List<String>> getRecentLocations(AuthUser user) async =>
      (await _loadUserData(user)).recentLocations;

  Future<UserData> _loadUserData(AuthUser user) async {
    final cacheId = user.username;
    if (!box.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return box.get(cacheId)!;
  }

  Future<void> _saveUserData(AuthUser user, UserData userData) async {
    final cacheId = user.username;

    await box.put(cacheId, userData);
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
