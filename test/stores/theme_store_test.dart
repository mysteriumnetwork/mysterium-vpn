import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await SharedPreferenceService.instance.init();
  });

  setUp(() async {
    // Each ThemeStore reads themeMode from prefs at construction; reset so
    // tests don't pollute each other.
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  test('themeMode defaults to system when no preference is stored', () {
    final store = ThemeStore();

    expect(store.themeMode, ThemeMode.system);
  });

  test('isDarkMode follows themeMode when explicitly set to dark', () async {
    final store = ThemeStore();

    await store.setThemeType(ThemeMode.dark);

    expect(store.themeMode, ThemeMode.dark);
    expect(store.isDarkMode, isTrue);
  });

  test('isDarkMode is false when explicitly set to light', () async {
    final store = ThemeStore();

    await store.setThemeType(ThemeMode.light);

    expect(store.themeMode, ThemeMode.light);
    expect(store.isDarkMode, isFalse);
  });

  test('isDarkMode follows systemTheme when themeMode is system', () {
    final store = ThemeStore();
    expect(store.themeMode, ThemeMode.system);

    store.systemTheme = true;
    expect(store.isDarkMode, isTrue);

    store.systemTheme = false;
    expect(store.isDarkMode, isFalse);
  });

  test('persists themeMode across instances via SharedPreferences', () async {
    final store = ThemeStore();
    await store.setThemeType(ThemeMode.dark);

    final fresh = ThemeStore();
    expect(fresh.themeMode, ThemeMode.dark);
  });

  test('updateSystemTheme refreshes systemTheme from platform brightness', () async {
    final store = ThemeStore();
    await store.updateSystemTheme();
    // The exact value depends on the host but the call must not throw.
    expect(store.systemTheme, isA<bool>());
  });
}
