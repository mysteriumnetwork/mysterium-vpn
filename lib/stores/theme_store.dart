// Flutter imports:
// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/styles/theme.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

// Project imports:

part 'theme_store.g.dart';

enum ThemeType {
  light("Light Theme"),
  dark("Dark Theme");

  const ThemeType(this.label);
  final String label;
}

// ignore: library_private_types_in_public_api
class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  _ThemeStore() {
    themeType = SharedPreferenceService.getThemeType() ??
        (SchedulerBinding.instance.window.platformBrightness == Brightness.dark
            ? ThemeType.dark
            : ThemeType.light);
  }

  @computed
  ThemeData get currentTheme => MysteriumVPNTheme.themeData(
      themeType == ThemeType.dark ? DarkPalette() : LightPalette());

  @observable
  ThemeType themeType = ThemeType.light;

  @action
  Future<void> setThemeType(ThemeType type) async {
    await SharedPreferenceService.setThemeType(type);
    themeType = type;
  }

  @action
  Future<void> switchTheme() async {
    final type =
        themeType == ThemeType.light ? ThemeType.dark : ThemeType.light;
    await SharedPreferenceService.setThemeType(type);
    themeType = type;
  }
}
