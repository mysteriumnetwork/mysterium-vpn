import 'dart:async';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/adapters/adapters.dart';
import 'package:mysterium_vpn/services/data/local/box_recovery.dart';
import 'package:mysterium_vpn/services/data/local/residential_education_storage.dart';

class LocalDBService implements ResidentialEducationStorage {
  factory LocalDBService() => instance;

  LocalDBService._();

  static final LocalDBService instance = LocalDBService._();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter())
      ..registerAdapter(const VPNLocationAdapter(typeId: 3))
      ..registerAdapter(const BannerTypeAdapter(typeId: 4))
      ..registerAdapter(const VpnLocationsAdapter(typeId: 5))
      ..registerAdapter(const LatLngAdapter(typeId: 6))
      ..registerAdapter(const ProtocolTypeAdapter(typeId: 7));

    await openBoxRecoverable<Box<UserData>>(
      name: 'user_data',
      open: () => Hive.openBox<UserData>('user_data'),
      validateKey: (box, key) async => box.get(key),
    );
  }

  final _userBox = Hive.box<UserData>('user_data');

  Completer<AuthUser> _userSetCompleter = Completer<AuthUser>();
  LazyBox<VPNLocations>? _locationsBox;

  Future<LazyBox<VPNLocations>> _getLocationsBox() async {
    // No open-time per-key validation: locations entries can be large and
    // iterating them all on first access would risk an ANR. Per-key recovery
    // happens in [getLocations] via [safeRead] instead.
    _locationsBox ??= await openBoxRecoverable<LazyBox<VPNLocations>>(
      name: 'locations_data',
      open: () => Hive.openLazyBox<VPNLocations>('locations_data'),
    );
    return _locationsBox!;
  }

  Future<void> setUser(AuthUser user) async {
    if (!_userSetCompleter.isCompleted) {
      _userSetCompleter.complete(user);
      return;
    }

    final value = await _userSetCompleter.future;
    if (value != user) {
      _userSetCompleter = Completer<AuthUser>();
      _userSetCompleter.complete(user);
    }
    unawaited(incrementAppOpenCount());
  }

  void clearUser() {
    if (_userSetCompleter.isCompleted) {
      _userSetCompleter = Completer<AuthUser>();
    }
  }

  Future<UserData> getUserData() async => _loadUserData();

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

  Future<bool> getMalwareContentBlocker() async => (await _loadUserData()).malwareContentBlocker;

  Future<void> setMalwareContentBlocker({required bool value}) async {
    final userData = await _loadUserData();
    userData.malwareContentBlocker = value;

    await _saveUserData(userData);
  }

  Future<bool> getNotSafeContentBlocker() async => (await _loadUserData()).notSafeContentBlocker;

  Future<void> setNotSafeContentBlocker({required bool value}) async {
    final userData = await _loadUserData();
    userData.notSafeContentBlocker = value;

    await _saveUserData(userData);
  }

  Future<void> setRecentLocations(List<VPNLocation> locations) async {
    final userData = await _loadUserData();
    userData.recentLocations = locations;

    await _saveUserData(userData);
  }

  Future<List<VPNLocation>> getRecentLocations() async => (await _loadUserData()).recentLocations;

  Stream<List<VPNLocation>> watchRecentLocations() =>
      _watchUserData().map((it) => it.recentLocations);

  Future<void> setShownBanners(List<BannerType> banners) async {
    final userData = await _loadUserData();
    userData.shownBanners = banners;

    await _saveUserData(userData);
  }

  Future<List<BannerType>> getShownBanners() async => (await _loadUserData()).shownBanners;

  Future<List<BannerType>> getMainBanners() async =>
      (await _loadUserData()).shownBanners.where((it) => it.mainBanner).toList();

  Future<List<BannerType>> getSecondaryBanners() async =>
      (await _loadUserData()).shownBanners.where((it) => !it.mainBanner).toList();

  Future<void> resetShownBanners() async {
    final userData = await _loadUserData();
    userData.shownBanners = [];

    await _saveUserData(userData);
  }

  Future<UserData> _loadUserData() async {
    final user = await _userSetCompleter.future;
    final cacheId = user.username;
    if (!_userBox.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return _userBox.get(cacheId)!;
  }

  Stream<UserData> _watchUserData() async* {
    final user = await _userSetCompleter.future;
    final cacheId = user.username;

    final current = await _loadUserData();

    yield current;

    yield* _userBox
        .watch(key: cacheId)
        .map((_) => _userBox.get(cacheId))
        .where((it) => it is UserData)
        .cast<UserData>();
  }

  Future<void> _saveUserData(UserData userData) async {
    final user = await _userSetCompleter.future;
    final cacheId = user.username;

    await _userBox.put(cacheId, userData);
  }

  Future<void> _setInitUserData(String key) async {
    await _userBox.put(key, UserData(userId: key, recentVPNLocations: []));
  }

  Future<void> setLocations(VPNLocations locations, {required IPType type}) async {
    final box = await _getLocationsBox();
    await box.put(type.name, locations);
  }

  Future<VPNLocations?> getLocations(IPType type) async {
    final box = await _getLocationsBox();
    return safeRead(box, type.name, () => box.get(type.name));
  }

  Stream<VPNLocations?> watchLocations(IPType type) async* {
    final box = await _getLocationsBox();
    yield* box.watch(key: type.name).asyncMap((_) => getLocations(type));
  }

  Future<bool> getMarketingConsentShown() async {
    final userData = await _loadUserData();
    return userData.marketingConsentShown;
  }

  Future<void> setMarketingConsentShown() async {
    final userData = await _loadUserData();
    userData.marketingConsentShown = true;

    await _saveUserData(userData);
  }

  Future<ProtocolType> getProtocolType() async {
    final userData = await _loadUserData();
    return userData.protocolType;
  }

  Future<void> setProtocolType(ProtocolType protocolType) async {
    final userData = await _loadUserData();
    userData.protocolType = protocolType;
    await _saveUserData(userData);
  }

  Future<DateTime?> getPushNotificationsPromptLastShownAt() async {
    final userData = await _loadUserData();
    return userData.pushNotificationsPromptLastShownAt;
  }

  Future<void> setPushNotificationsPromptLastShownAt(DateTime dateTime) async {
    final userData = await _loadUserData();
    userData.pushNotificationsPromptLastShownAt = dateTime;
    await _saveUserData(userData);
  }

  Future<void> resetPushNotificationsPromptLastShownAt() async {
    final userData = await _loadUserData();
    userData.pushNotificationsPromptLastShownAt = null;
    await _saveUserData(userData);
  }

  Future<int> getAppOpenCount() async {
    final userData = await _loadUserData();
    return userData.appOpenCount;
  }

  Future<void> incrementAppOpenCount() async {
    final userData = await _loadUserData();
    userData.appOpenCount = userData.appOpenCount + 1;
    await _saveUserData(userData);
  }

  Future<void> resetAppOpenCount() async {
    final userData = await _loadUserData();
    userData.appOpenCount = 0;
    await _saveUserData(userData);
  }

  Future<bool> getNoneSubsOnboardingCompleted() async {
    final userData = await _loadUserData();
    return userData.noneSubsOnboardingCompleted;
  }

  Future<void> setNoneSubsOnboardingCompleted() async {
    final userData = await _loadUserData();
    userData.noneSubsOnboardingCompleted = true;
    await _saveUserData(userData);
  }

  Future<bool> getSubscriptionOnboardingShown() async {
    final userData = await _loadUserData();
    return userData.subscriptionOnboardingShown;
  }

  Future<void> setSubscriptionOnboardingShown() async {
    final userData = await _loadUserData();
    userData.subscriptionOnboardingShown = true;
    await _saveUserData(userData);
  }

  Future<void> resetSubscriptionOnboardingShown() async {
    final userData = await _loadUserData();
    userData.subscriptionOnboardingShown = false;
    await _saveUserData(userData);
  }

  /// Clears both the completion flag and the saved step so onboarding starts
  /// over from step 0 on the next launch. Used by the QA toolbox.
  Future<void> resetNoneSubsOnboarding() async {
    final userData = await _loadUserData();
    userData
      ..noneSubsOnboardingCompleted = false
      ..noneSubsOnboardingStep = 0;
    await _saveUserData(userData);
  }

  Future<int> getNoneSubsOnboardingStep() async {
    final userData = await _loadUserData();
    return userData.noneSubsOnboardingStep;
  }

  Future<void> setNoneSubsOnboardingStep(int step) async {
    final userData = await _loadUserData();
    userData.noneSubsOnboardingStep = step;
    await _saveUserData(userData);
  }

  // ── ResidentialEducationStorage (per-user, in UserData) ──────────────────

  @override
  Future<bool> getEducationModalShown() async =>
      (await _loadUserData()).residentialEducationModalShown;

  @override
  Future<void> setEducationModalShown({required bool value}) async {
    final userData = await _loadUserData();
    userData.residentialEducationModalShown = value;
    await _saveUserData(userData);
  }

  @override
  Future<DateTime?> getEducationReminderAt() async =>
      (await _loadUserData()).residentialReminderShownAt;

  @override
  Future<void> setEducationReminderAt(DateTime value) async {
    final userData = await _loadUserData();
    userData.residentialReminderShownAt = value;
    await _saveUserData(userData);
  }

  @override
  Future<int> getResidentialConnectCount() async => (await _loadUserData()).residentialConnectCount;

  @override
  Future<void> setResidentialConnectCount(int value) async {
    final userData = await _loadUserData();
    userData.residentialConnectCount = value;
    await _saveUserData(userData);
  }

  @override
  Future<void> clearEducationState() async {
    final userData = await _loadUserData();
    userData
      ..residentialEducationModalShown = false
      ..residentialReminderShownAt = null
      ..residentialConnectCount = 0;
    await _saveUserData(userData);
  }
}
