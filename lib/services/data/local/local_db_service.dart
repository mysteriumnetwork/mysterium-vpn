import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_data.dart';
import 'package:mysterium_vpn/services/auth/auth_user.dart';
import 'package:mysterium_vpn/services/data/local/adapters/banner_type_adapter.dart';
import 'package:mysterium_vpn/services/data/local/adapters/lat_lng_adapter.dart';
import 'package:mysterium_vpn/services/data/local/adapters/vpn_location_adapter.dart';
import 'package:mysterium_vpn/services/data/local/adapters/vpn_locations_adapter.dart';

class LocalDBService {
  factory LocalDBService() => instance;

  LocalDBService._();

  static final LocalDBService instance = LocalDBService._();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter())
      ..registerAdapter(VPNLocationAdapter(typeId: 3))
      ..registerAdapter(BannerTypeAdapter(typeId: 4))
      ..registerAdapter(VpnLocationsAdapter(typeId: 5))
      ..registerAdapter(LatLngAdapter(typeId: 6));

    await Future.wait([
      Hive.openBox<UserData>('user_data', compactionStrategy: (e, d) => false),
      Hive.openBox<VPNLocations>('locations_data', compactionStrategy: (e, d) => false),
      Hive.openBox<LatLng>('coordinates_data', compactionStrategy: (e, d) => false),
    ]);
  }

  final _userBox = Hive.box<UserData>('user_data');
  final _locationsBox = Hive.box<VPNLocations>('locations_data');
  final _coordinatesBox = Hive.box<LatLng>('coordinates_data');

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
    final user = await _ensureUserSet();
    final cacheId = user.username;
    if (!_userBox.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    return _userBox.get(cacheId)!;
  }

  Stream<UserData> _watchUserData() async* {
    final user = await _ensureUserSet();
    final cacheId = user.username;

    if (!_userBox.containsKey(cacheId)) {
      await _setInitUserData(cacheId);
    }

    yield* _userBox
        .watch(key: cacheId)
        .map((_) => _userBox.get(cacheId))
        .where((it) => it != null)
        .cast();
  }

  Future<void> _saveUserData(UserData userData) async {
    final cacheId = _currentUser!.username;

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
    await _locationsBox.put(type.name, locations);
  }

  VPNLocations? getLocations(IPType type) => _locationsBox.get(type.name);

  Stream<VPNLocations?> watchLocations(IPType type) async* {
    yield* _locationsBox.watch(key: type.name).asyncMap((_) => getLocations(type));
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

  Future<void> setFavouriteLocations(List<VPNLocation> locations) async {
    final userData = await _loadUserData();
    userData.favouriteLocations = locations;

    await _saveUserData(userData);
  }

  Future<List<VPNLocation>> getFavouriteLocations() async {
    final userData = await _loadUserData();
    return userData.favouriteLocations;
  }

  Stream<List<VPNLocation>> watchFavouriteLocations() =>
      _watchUserData().map((it) => it.favouriteLocations);
}
