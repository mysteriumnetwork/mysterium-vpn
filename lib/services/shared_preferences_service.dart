// Dart imports:
import 'dart:async' show Future;

import 'package:collection/collection.dart';
// Package imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  factory SharedPreferenceService() => _instance;
  SharedPreferenceService._internal();
  static final SharedPreferenceService _instance = SharedPreferenceService._internal();

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

  bool containsKey(String key) => _prefsInstance.containsKey(key);

  Locale? getLocale() {
    final languageCode = getString(StorageKeys.languageCode.value);
    return languageCode != null
        ? kSupportedLocales.firstWhereOrNull(
            (e) => e.languageCode == languageCode,
          )
        : null;
  }

  Future<bool> setLocale(Locale locale) async =>
      setString(StorageKeys.languageCode.value, locale.languageCode);

  ThemeMode? getThemeType() {
    final themeType = getString(StorageKeys.themeMype.value);
    return ThemeMode.values.firstWhereOrNull((e) => e.value == themeType);
  }

  Future<bool> setThemeType(ThemeMode themeMode) async =>
      setString(StorageKeys.themeMype.value, themeMode.value);

  bool? getVpnConfigConsent() => getBool(StorageKeys.vpnConfigConsent.value);

  Future<bool> setVpnConfigConsent({required bool vpnConfigConsent}) async =>
      setBool(StorageKeys.vpnConfigConsent.value, value: vpnConfigConsent);
}
