// Flutter imports:
// Package imports:
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/styles/theme.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

// Project imports:

part 'theme_store.g.dart';

// ignore: library_private_types_in_public_api
class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  _ThemeStore() {
    themeMode = SharedPreferenceService.getThemeType() ?? ThemeMode.system;
  }

  final darkTheme = MysteriumVPNTheme.themeData(DarkPalette());
  final lightTheme = MysteriumVPNTheme.themeData(LightPalette());

  @observable
  ThemeMode themeMode = ThemeMode.system;

  @computed
  bool get isDarkMode => themeMode == ThemeMode.system
      ? window.platformBrightness == Brightness.dark
      : themeMode == ThemeMode.dark;

  @action
  Future<void> setThemeType(ThemeMode mode) async {
    await SharedPreferenceService.setThemeType(mode);
    themeMode = mode;
  }
}
