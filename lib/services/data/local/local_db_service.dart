import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';

class LocalDBService {
  factory LocalDBService() => instance;
  LocalDBService._();

  static final LocalDBService instance = LocalDBService._();

  final box = Hive.box<UserData>('user_data');
  final Completer<void> _userSetCompleter = Completer<void>();
  late AuthUser _currentUser;

  Future<void> setUser(AuthUser user) async {
    _currentUser = user;
    if (!_userSetCompleter.isCompleted) {
      _userSetCompleter.complete();
    }
  }

  Future<void> _ensureUserSet() async {
    await _userSetCompleter.future;
  }

  Future<UserData> getUserData() async {
    await _ensureUserSet();
    return _loadUserData(_currentUser);
  }

  Future<void> setNotificationsApproval({required bool approval}) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.notifications = approval ? Approval.approved : Approval.declined;

    await _saveUserData(userData);
  }

  Future<Approval> getNotificationsApproval() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).notifications;
  }

  Future<void> setVpnConsentApproval({required bool approval}) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.vpnConfigConsent = approval;

    await _saveUserData(userData);
  }

  Future<bool?> getVpnConsentApproval() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).vpnConfigConsent;
  }

  Future<bool> getRefreshIPConnection() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).refreshIPConnection;
  }

  Future<void> setRefreshIPConnection({required bool refreshIPConnection}) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.refreshIPConnection = refreshIPConnection;

    await _saveUserData(userData);
  }

  Future<bool> getMalwareBlocker() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).malwareBlocker;
  }

  Future<void> setMalwareBlocker({required bool malwareBlocker}) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.malwareBlocker = malwareBlocker;

    await _saveUserData(userData);
  }

  Future<bool> getNotSafeContentBlocker() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).notSafeContentBlocker;
  }

  Future<void> setNotSafeContentBlocker({required bool notSafeContentBlocker}) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.notSafeContentBlocker = notSafeContentBlocker;

    await _saveUserData(userData);
  }

  Future<void> setRecentLocation(List<String> locations) async {
    await _ensureUserSet();
    final userData = await _loadUserData(_currentUser);
    userData.recentLocations = locations;

    await _saveUserData(userData);
  }

  Future<List<String>> getRecentLocations() async {
    await _ensureUserSet();
    return (await _loadUserData(_currentUser)).recentLocations;
  }

  Future<UserData> _loadUserData(AuthUser user) async {
    final cacheId = user.username;
    if (!box.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return box.get(cacheId)!;
  }

  Future<void> _saveUserData(UserData userData) async {
    final cacheId = _currentUser.username;

    await box.put(cacheId, userData);
  }

  Future<void> _setInitUserData(String key) async {
    await box.put(
      key,
      UserData(
        userId: key,
        recentLocations: [],
      ),
    );
  }
}
