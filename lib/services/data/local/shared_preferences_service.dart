// Dart imports:
import 'dart:async' show Future;
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
// Package imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/models/models.dart';
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

  /// Every stored key/value, for the QA debug viewer. Order is unspecified.
  Map<String, Object?> readAll() => {
    for (final key in _prefsInstance.getKeys()) key: _prefsInstance.get(key),
  };

  bool checkExistance(StorageKeys key) => _prefsInstance.containsKey(key.name);

  Locale getLocale() {
    final stored = getString(StorageKeys.languageCode.name);
    final source = stored != null ? _parseLanguageTag(stored) : PlatformDispatcher.instance.locale;

    // Prefer an exact tag match so country variants (e.g. pt-BR vs pt) are
    // preserved, then fall back to language only, then the app default.
    return supportedLocales.firstWhereOrNull((e) => e.toLanguageTag() == source.toLanguageTag()) ??
        supportedLocales.firstWhereOrNull((e) => e.languageCode == source.languageCode) ??
        kFallbackLocale;
  }

  Future<bool> setLocale(Locale locale) async =>
      setString(StorageKeys.languageCode.name, locale.toLanguageTag());

  // Parses a persisted BCP-47 tag ('pt-BR', 'fr', legacy 'fr-FR') into a Locale.
  Locale _parseLanguageTag(String tag) {
    final parts = tag.split('-');
    return parts.length > 1 ? Locale(parts.first, parts[1]) : Locale(parts.first);
  }

  ThemeMode? getThemeType() {
    final themeType = getString(StorageKeys.themeMype.name);
    return ThemeMode.values.firstWhereOrNull((e) => e.name == themeType);
  }

  Future<bool> setThemeType(ThemeMode themeMode) async =>
      setString(StorageKeys.themeMype.name, themeMode.name);

  Future<bool> setAppInstallDay(int value) async => setInt(StorageKeys.appInstallDay.name, value);
  int? getAppInstallDay() => getInt(StorageKeys.appInstallDay.name);

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

  Future<void> setPushNotificationsShown({required bool shown}) async =>
      setBool(StorageKeys.pushNotificationsPermissionPromptShown.name, value: shown);

  bool getPushNotificationsShown() =>
      getBool(StorageKeys.pushNotificationsPermissionPromptShown.name) ?? false;

  // ─── Review prompt ──────────────────────────────────────────────────────

  int getReviewAppOpenCount() => getInt(StorageKeys.reviewAppOpenCount.name) ?? 0;
  Future<bool> setReviewAppOpenCount(int value) async =>
      setInt(StorageKeys.reviewAppOpenCount.name, value);

  int getReviewSuccessfulConnections() => getInt(StorageKeys.reviewSuccessfulConnections.name) ?? 0;
  Future<bool> setReviewSuccessfulConnections(int value) async =>
      setInt(StorageKeys.reviewSuccessfulConnections.name, value);

  /// Outcomes of the most recent sessions, newest last (`true` = success).
  List<bool> getReviewRecentSessionOutcomes() {
    final raw = getStringList(StorageKeys.reviewRecentSessionOutcomes.name);
    if (raw == null) {
      return const [];
    }
    return raw.map((it) => it == 'true').toList();
  }

  Future<bool> setReviewRecentSessionOutcomes(List<bool> value) async => setStringList(
    StorageKeys.reviewRecentSessionOutcomes.name,
    value.map((it) => '$it').toList(),
  );

  int? getReviewCooldownUntil() => getInt(StorageKeys.reviewCooldownUntil.name);
  Future<bool> setReviewCooldownUntil(int value) async =>
      setInt(StorageKeys.reviewCooldownUntil.name, value);

  /// Epoch-millis timestamps of every prompt display (drives the yearly cap).
  List<int> getReviewPromptShownTimestamps() {
    final raw = getStringList(StorageKeys.reviewPromptShownTimestamps.name);
    if (raw == null) {
      return const [];
    }
    return raw.map(int.tryParse).whereType<int>().toList();
  }

  Future<bool> setReviewPromptShownTimestamps(List<int> value) async => setStringList(
    StorageKeys.reviewPromptShownTimestamps.name,
    value.map((it) => '$it').toList(),
  );

  int? getReviewNativeReviewOpenedAt() => getInt(StorageKeys.reviewNativeReviewOpenedAt.name);
  Future<bool> setReviewNativeReviewOpenedAt(int value) async =>
      setInt(StorageKeys.reviewNativeReviewOpenedAt.name, value);

  /// Clears all persisted review-prompt state (counters, cooldown, yearly-cap
  /// timestamps, native-review marker). Used by the QA toolbox to re-test.
  Future<void> resetReviewPromptState() async {
    await Future.wait([
      remove(StorageKeys.reviewAppOpenCount.name),
      remove(StorageKeys.reviewSuccessfulConnections.name),
      remove(StorageKeys.reviewRecentSessionOutcomes.name),
      remove(StorageKeys.reviewCooldownUntil.name),
      remove(StorageKeys.reviewPromptShownTimestamps.name),
      remove(StorageKeys.reviewNativeReviewOpenedAt.name),
    ]);
  }
}
