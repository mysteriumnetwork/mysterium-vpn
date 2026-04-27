// Flutter imports:
// Package imports:

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// Project imports:

part 'theme_store.g.dart';

// ignore: library_private_types_in_public_api
class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  _ThemeStore() {
    themeMode = _sharedPrefs.getThemeType() ?? ThemeMode.system;
  }
  final _sharedPrefs = SharedPreferenceService.instance;
  final darkTheme = DesignSystem.darkTheme;
  final lightTheme = DesignSystem.lightTheme;

  @observable
  ThemeMode themeMode = ThemeMode.system;

  @observable
  bool systemTheme =
      WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  @computed
  bool get isDarkMode => themeMode == ThemeMode.system ? systemTheme : themeMode == ThemeMode.dark;

  @action
  Future<void> setThemeType(ThemeMode mode) async {
    await _sharedPrefs.setThemeType(mode);
    themeMode = mode;
  }

  @action
  Future<void> updateSystemTheme() async {
    systemTheme = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }
}
