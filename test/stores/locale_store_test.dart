import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  test('seeds currentLocale from SharedPreferenceService', () {
    final store = LocaleStore();
    expect(store.currentLocale, kFallbackLocale);
  });

  test('setLocale persists and updates a supported locale', () async {
    final store = LocaleStore();
    final supported = kSupportedLocales.first;

    await store.setLocale(supported);

    expect(store.currentLocale, supported);
    final fresh = LocaleStore();
    expect(fresh.currentLocale, supported);
  });

  test('setLocale ignores unsupported locales', () async {
    final store = LocaleStore();
    final original = store.currentLocale;
    const unsupported = Locale('zz');

    await store.setLocale(unsupported);

    expect(store.currentLocale, original);
  });
}
