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

  static Future<SharedPreferences> init() async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  String? getString(String key) => _prefsInstance!.getString(key);

  int? getInt(String key) => _prefsInstance!.getInt(key);

  bool? getBool(String key) => _prefsInstance!.getBool(key);

  Future<bool> setString(String key, String value) async => _prefsInstance!.setString(key, value);

  Future<bool> setInt(String key, int value) async => _prefsInstance!.setInt(key, value);

  Future<bool> setBool(String key, {required bool value}) async =>
      _prefsInstance!.setBool(key, value);

  Future<bool> remove(String key) async => _prefsInstance!.remove(key);

  Future<bool> clear() async => _prefsInstance!.clear();

  bool containsKey(String key) => _prefsInstance!.containsKey(key);

  Locale? getLocale() {
    final languageCode = getString(StorageKeys.languageCode.value);
    final countryCode = getString(StorageKeys.countryCode.value);
    return languageCode != null ? Locale(languageCode, countryCode) : null;
  }

  Future<bool> setLocale(Locale locale) async {
    if (locale.countryCode != null) {
      await setString(StorageKeys.countryCode.value, locale.countryCode!);
    }
    return setString(StorageKeys.languageCode.value, locale.languageCode);
  }

  ThemeMode? getThemeType() {
    final themeType = getString(StorageKeys.themeMype.value);
    return ThemeMode.values.firstWhereOrNull((e) => e.value == themeType);
  }

  Future<bool> setThemeType(ThemeMode themeMode) async =>
      setString(StorageKeys.themeMype.value, themeMode.value);

  //Only for testing
  Future<bool> setSubscriptionPlan(
    String productId,
    String purchaseId,
  ) async {
    await setString(StorageKeys.subscriptionPlanProductId.value, productId);
    return setString(StorageKeys.subscriptionPlanPurchaseId.value, purchaseId);
  }

  String? getSubscriptionProductId() => getString(StorageKeys.subscriptionPlanProductId.value);
  String? getSubscriptionPurchaseId() => getString(StorageKeys.subscriptionPlanProductId.value);
}
