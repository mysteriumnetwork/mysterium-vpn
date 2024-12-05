import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';

class LocalDBService {
  factory LocalDBService() => instance;
  LocalDBService._();

  static final LocalDBService instance = LocalDBService._();

  final box = Hive.box<UserData>('user_data');
  Completer<AuthUser> _userSetCompleter = Completer<AuthUser>();
  AuthUser? _currentUser;

  Future<void> setUser(AuthUser user) async {
    _currentUser = user;
    if (!_userSetCompleter.isCompleted) {
      _userSetCompleter.complete(user);
    }
  }

  void clearUser() {
    _currentUser = null;
    if (_userSetCompleter.isCompleted) {
      _userSetCompleter = Completer<AuthUser>();
    }
  }

  Future<AuthUser> _ensureUserSet() async => _userSetCompleter.future;

  Future<UserData> getUserData() async {
    final user = await _ensureUserSet();
    return _loadUserData(user);
  }

  Future<void> setNotificationsApproval({required bool approval}) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.notifications = approval ? Approval.approved : Approval.declined;

    await _saveUserData(userData);
  }

  Future<Approval> getNotificationsApproval() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).notifications;
  }

  Future<void> setVpnConsentApproval({required bool approval}) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.vpnConfigConsent = approval;

    await _saveUserData(userData);
  }

  Future<bool?> getVpnConsentApproval() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).vpnConfigConsent;
  }

  Future<bool> getRefreshIPConnection() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).refreshIPConnection;
  }

  Future<void> setRefreshIPConnection({required bool refreshIPConnection}) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.refreshIPConnection = refreshIPConnection;

    await _saveUserData(userData);
  }

  Future<bool> getMalwareBlocker() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).malwareBlocker;
  }

  Future<void> setMalwareBlocker({required bool malwareBlocker}) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.malwareBlocker = malwareBlocker;

    await _saveUserData(userData);
  }

  Future<bool> getNotSafeContentBlocker() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).notSafeContentBlocker;
  }

  Future<void> setNotSafeContentBlocker({required bool notSafeContentBlocker}) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.notSafeContentBlocker = notSafeContentBlocker;

    await _saveUserData(userData);
  }

  Future<void> setRecentLocation(List<String> locations) async {
    final user = await _ensureUserSet();
    final userData = await _loadUserData(user);
    userData.recentLocations = locations;

    await _saveUserData(userData);
  }

  Future<List<String>> getRecentLocations() async {
    final user = await _ensureUserSet();
    return (await _loadUserData(user)).recentLocations;
  }

  Future<UserData> _loadUserData(AuthUser user) async {
    final cacheId = user.username;
    if (!box.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return box.get(cacheId)!;
  }

  Future<void> _saveUserData(UserData userData) async {
    final cacheId = _currentUser!.username;

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
