import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/models/location.dart';
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

  Future<UserData> getUserData() async => _loadUserData();

  Future<void> setNotificationsApproval({required bool approval}) async {
    final userData = await _loadUserData();
    userData.notifications = approval ? Approval.approved : Approval.declined;

    await _saveUserData(userData);
  }

  Future<Approval> getNotificationsApproval() async => (await _loadUserData()).notifications;

  Future<void> setVpnPrivacyPolicyConsent({required bool approval}) async {
    final userData = await _loadUserData();
    userData.vpnPrivacyPolicyConsent = approval;

    await _saveUserData(userData);
  }

  Future<bool> getVpnPrivacyPolicyConsent() async =>
      (await _loadUserData()).vpnPrivacyPolicyConsent;

  Future<bool> getRefreshIPConnection() async => (await _loadUserData()).refreshIPConnection;

  Future<void> setRefreshIPConnection({required bool refreshIPConnection}) async {
    final userData = await _loadUserData();
    userData.refreshIPConnection = refreshIPConnection;

    await _saveUserData(userData);
  }

  Future<bool> getMalwareBlocker() async => (await _loadUserData()).malwareBlocker;

  Future<void> setMalwareBlocker({required bool malwareBlocker}) async {
    final userData = await _loadUserData();
    userData.malwareBlocker = malwareBlocker;

    await _saveUserData(userData);
  }

  Future<bool> getNotSafeContentBlocker() async => (await _loadUserData()).notSafeContentBlocker;

  Future<void> setNotSafeContentBlocker({required bool notSafeContentBlocker}) async {
    final userData = await _loadUserData();
    userData.notSafeContentBlocker = notSafeContentBlocker;

    await _saveUserData(userData);
  }

  Future<void> setRecentLocation(List<VPNLocation> locations) async {
    final userData = await _loadUserData();
    userData.recentLocations = locations;

    await _saveUserData(userData);
  }

  Future<List<VPNLocation>> getRecentLocations() async => (await _loadUserData()).recentLocations;

  Future<void> setShownBanners(List<BannerType> banners) async {
    final userData = await _loadUserData();
    userData.shownBanners = banners;

    await _saveUserData(userData);
  }

  Future<List<BannerType>> getShownBanners() async => (await _loadUserData()).shownBanners;

  Future<UserData> _loadUserData() async {
    final user = await _ensureUserSet();
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
        recentLocationCodes: [],
        recentVPNLocations: [],
      ),
    );
  }
}
