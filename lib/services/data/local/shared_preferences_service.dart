// Dart imports:
import 'dart:async' show Future;
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
// Package imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  factory SharedPreferenceService() => instance;
  SharedPreferenceService._internal();
  static final SharedPreferenceService instance = SharedPreferenceService._internal();

  late SharedPreferences _prefsInstance;

  Future<void> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefsInstance.getString(key);

  List<String>? getStringList(String key) => _prefsInstance.getStringList(key);

  int? getInt(String key) => _prefsInstance.getInt(key);

  bool? getBool(String key) => _prefsInstance.getBool(key);

  Future<bool> setString(String key, String value) async => _prefsInstance.setString(key, value);

  Future<bool> setInt(String key, int value) async => _prefsInstance.setInt(key, value);

  Future<bool> setStringList(String key, List<String> value) async =>
      _prefsInstance.setStringList(key, value);

  Future<bool> setBool(String key, {required bool value}) async =>
      _prefsInstance.setBool(key, value);

  Future<bool> remove(String key) async => _prefsInstance.remove(key);

  Future<bool> clear() async => _prefsInstance.clear();

  bool checkExistance(StorageKeys key) => _prefsInstance.containsKey(key.name);

  Locale getLocale() {
    final languageCode =
        getString(StorageKeys.languageCode.name) ?? PlatformDispatcher.instance.locale;

    return kSupportedLocales.firstWhereOrNull(
          (e) => e.languageCode == languageCode,
        ) ??
        kFallbackLocale;
  }

  Future<bool> setLocale(Locale locale) async =>
      setString(StorageKeys.languageCode.name, locale.languageCode);

  ThemeMode? getThemeType() {
    final themeType = getString(StorageKeys.themeMype.name);
    return ThemeMode.values.firstWhereOrNull((e) => e.name == themeType);
  }

  Future<bool> setThemeType(ThemeMode themeMode) async =>
      setString(StorageKeys.themeMype.name, themeMode.name);

  Future<bool> setAppInstallDay(int value) async => setInt(StorageKeys.appInstallDay.name, value);
  int? getAppInstallDay() => getInt(StorageKeys.appInstallDay.name);
  int? getRemindTimeStamp() => getInt(StorageKeys.inAppReviewRemindInterval.name);
  Future<bool> setRemindTimeStamp(int value) async =>
      setInt(StorageKeys.inAppReviewRemindInterval.name, value);

  Future<void> setIPInfo(IPInfo? info) async {
    if (info == null) {
      await remove(StorageKeys.ipInfo.name);
      return;
    }

    await setString(StorageKeys.ipInfo.name, jsonEncode(info.toJson()));
  }

  IPInfo? getIPInfo() {
    final ipInfo = getString(StorageKeys.ipInfo.name);
    if (ipInfo == null) {
      return null;
    }

    return IPInfo.fromJson(jsonDecode(ipInfo) as Map<String, dynamic>);
  }

  Future<void> setIPType(IPType type) async => setString(StorageKeys.ipType.name, type.name);

  IPType? getIPType() {
    final ipType = getString(StorageKeys.ipType.name);
    if (ipType == null) {
      return null;
    }

    return IPType.fromName(ipType);
  }

  Future<void> setPanelState(PanelState state) async => setString(
        StorageKeys.panelState.name,
        state.name,
      );

  PanelState? getPanelState() {
    final panelState = getString(StorageKeys.panelState.name);
    if (panelState == null) {
      return null;
    }

    return PanelState.fromName(panelState);
  }

  Future<void> setPushNotificationsShown({required bool shown}) async => setBool(
        StorageKeys.pushNotificationsPermissionPromptShown.name,
        value: shown,
      );

  bool getPushNotificationsShown() {
    final shown = getBool(StorageKeys.pushNotificationsPermissionPromptShown.name);
    if (shown == null) {
      return false;
    }

    return shown;
  }
}
