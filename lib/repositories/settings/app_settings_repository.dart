import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';

/// Single source of truth for the user's persisted app-level settings.
abstract class AppSettingsRepository {
  Locale locale();

  Future<void> setLocale(Locale locale);

  ThemeMode? themeMode();

  Future<void> setThemeMode(ThemeMode themeMode);

  IPType? ipType();

  Future<void> setIpType(IPType type);
}

/// [AppSettingsRepository] backed by [SharedPreferenceService].
class LocalAppSettingsRepository implements AppSettingsRepository {
  LocalAppSettingsRepository(this._prefs);

  final SharedPreferenceService _prefs;

  @override
  Locale locale() => _prefs.getLocale();

  @override
  Future<void> setLocale(Locale locale) => _prefs.setLocale(locale);

  @override
  ThemeMode? themeMode() => _prefs.getThemeType();

  @override
  Future<void> setThemeMode(ThemeMode themeMode) => _prefs.setThemeType(themeMode);

  @override
  IPType? ipType() => _prefs.getIPType();

  @override
  Future<void> setIpType(IPType type) => _prefs.setIPType(type);
}
