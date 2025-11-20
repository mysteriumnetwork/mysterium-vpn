import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/adapters/adapters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LocalDBService {
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
      ..registerAdapter(
        const ProtocolTypeAdapter(typeId: 7),
      );

    try {
      await Future.wait([
        Hive.openBox<UserData>('user_data'),
        Hive.openBox<LatLng>('coordinates_data'),
      ]);
    } catch (e) {
      // If we fail to open the boxes, we log the error and continue.
      // This can happen if the database is corrupted.
      // In this case, we delete the boxes and try to open them again.
      // This will result in loss of data, but at least the app will continue to work.
      // In a real app, we might want to notify the user about this.
      debugPrint('Failed to open Hive boxes: $e');
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap(
          {
            'hint': 'Failed to open Hive boxes, deleting and recreating them',
          },
        ),
      );
      await Hive.deleteBoxFromDisk('user_data');
      await Hive.deleteBoxFromDisk('coordinates_data');
      await Future.wait([
        Hive.openBox<UserData>('user_data'),
        Hive.openBox<LatLng>('coordinates_data'),
      ]);
    }
  }

  final _userBox = Hive.box<UserData>('user_data');
  final _coordinatesBox = Hive.box<LatLng>('coordinates_data');

  Completer<AuthUser> _userSetCompleter = Completer<AuthUser>();
  LazyBox<VPNLocations>? _locationsBox;

  Future<LazyBox<VPNLocations>> _getLocationsBox() async {
    _locationsBox ??= await Hive.openLazyBox<VPNLocations>('locations_data');
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

  Future<List<BannerType>> getMainBanners() async => (await _loadUserData())
      .shownBanners
      .where(
        (it) => it.mainBanner,
      )
      .toList();

  Future<List<BannerType>> getSecondaryBanners() async => (await _loadUserData())
      .shownBanners
      .where(
        (it) => !it.mainBanner,
      )
      .toList();

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
    await _userBox.put(
      key,
      UserData(
        userId: key,
        recentVPNLocations: [],
      ),
    );
  }

  Future<void> setLocations(VPNLocations locations, {required IPType type}) async {
    final box = await _getLocationsBox();
    await box.put(type.name, locations);
  }

  Future<VPNLocations?> getLocations(IPType type) async {
    final box = await _getLocationsBox();
    return box.get(type.name);
  }

  Stream<VPNLocations?> watchLocations(IPType type) async* {
    final box = await _getLocationsBox();
    yield* box.watch(key: type.name).asyncMap((_) => getLocations(type));
  }

  Future<void> putCoordinates(String id, LatLng coordinates) async {
    await _coordinatesBox.put(id, coordinates);
  }

  LatLng? getCoordinates(String id) => _coordinatesBox.get(id);

  Future<void> deleteCoordinates(String id) async {
    await _coordinatesBox.delete(id);
  }

  Map<String, LatLng> getAllCoordinates() {
    final coordinates = _coordinatesBox.toMap();
    return {
      for (final entry in coordinates.entries) entry.key.toString(): entry.value,
    };
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
}
