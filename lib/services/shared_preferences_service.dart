// Dart imports:
import 'dart:async' show Future;

import 'package:collection/collection.dart';
// Package imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return _prefsInstance!.getString(key);
  }

  static int? getInt(String key) {
    return _prefsInstance!.getInt(key);
  }

  static bool? getBool(String key) {
    return _prefsInstance!.getBool(key);
  }

  static Future<bool> setString(String key, String value) async {
    return _prefsInstance!.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return _prefsInstance!.setInt(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefsInstance!.setBool(key, value);
  }

  static Future<bool> remove(String key) async {
    return _prefsInstance!.remove(key);
  }

  static Future<bool> clear() async {
    return _prefsInstance!.clear();
  }

  static bool containsKey(String key) {
    return _prefsInstance!.containsKey(key);
  }

  static Locale? getLocale() {
    final String? languageCode = getString(StorageKeys.languageCode.value);
    final String? countryCode = getString(StorageKeys.countryCode.value);
    return languageCode != null ? Locale(languageCode, countryCode) : null;
  }

  static Future<bool> setLocale(Locale locale) async {
    if (locale.countryCode != null) {
      await setString(StorageKeys.countryCode.value, locale.countryCode!);
    }
    return await setString(StorageKeys.languageCode.value, locale.languageCode);
  }

  static ThemeMode? getThemeType() {
    final String? themeType = getString(StorageKeys.themeMype.value);
    return ThemeMode.values.firstWhereOrNull((e) => e.value == themeType);
  }

  static Future<bool> setThemeType(ThemeMode themeMode) async {
    return await setString(StorageKeys.themeMype.value, themeMode.value);
  }
}
