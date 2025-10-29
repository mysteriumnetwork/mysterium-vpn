import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'device_id_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SecureStorageService>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<AndroidDeviceInfo>(),
  MockSpec<IosDeviceInfo>(),
  MockSpec<MacOsDeviceInfo>(),
  MockSpec<WindowsDeviceInfo>(),
])
void main() {
  late MockSecureStorageService mockStorage;
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;
  late DeviceIDStore store;
  const mockDeviceID = '3f8d7cb624d30561e803a6e3e0572fd59fe8ff721a12609212bc9262f5c32fb7';

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    store = DeviceIDStore(
      secureStorageService: mockStorage,
      deviceInfoPlugin: mockDeviceInfoPlugin,
      flutterUdid: () async => mockDeviceID,
    );
  });

  group('getDeviceId', () {
    test('uses flutterUdid when stored deviceId is already a SHA256 digest', () async {
      when(mockStorage.getDeviceId()).thenAnswer((_) async => mockDeviceID);
      when(mockStorage.saveDeviceId(any)).thenAnswer((_) async => {});

      final id = await store.getDeviceId();

      // Compute expected truncated SHA256
      final expected = sha256.convert(utf8.encode(mockDeviceID)).toString().substring(0, 36);
      expect(id, expected);

      verify(mockStorage.getDeviceId()).called(greaterThanOrEqualTo(1));
      verify(mockStorage.saveDeviceId(expected)).called(greaterThanOrEqualTo(1));
    });

    test('returns stored deviceId if it is not a SHA256 digest', () async {
      const plainId = 'not-a-sha';
      when(mockStorage.getDeviceId()).thenAnswer((_) async => plainId);

      final localStore = DeviceIDStore(
        secureStorageService: mockStorage,
        deviceInfoPlugin: mockDeviceInfoPlugin,
        flutterUdid: () async => 'mockUdid',
      );

      final id = await localStore.getDeviceId();
      final expected = sha256.convert(utf8.encode('mockUdid')).toString().substring(0, 36);
      expect(id, expected);

      verify(mockStorage.getDeviceId()).called(greaterThanOrEqualTo(1));
      verify(mockStorage.saveDeviceId(expected)).called(greaterThanOrEqualTo(1));
    });

    test('falls back to getDeviceIdFromDeviceInfo on error', () async {
      when(mockStorage.getDeviceId()).thenThrow(Exception('fail'));

      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('android-fallback');
      when(mockStorage.saveDeviceId(any)).thenAnswer((_) async => {});

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      final expected = sha256.convert(utf8.encode('android-fallback')).toString().substring(0, 36);

      expect(id, expected);
    });
  });

  group('getDeviceIdFromDeviceInfo', () {
    test('returns hashed androidId on Android', () async {
      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('android-id-123');

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      final expected = sha256.convert(utf8.encode('android-id-123')).toString().substring(0, 36);

      expect(id, expected);
    });

    test('returns hashed identifierForVendor on iOS', () async {
      final mockIosInfo = MockIosDeviceInfo();
      when(mockDeviceInfoPlugin.iosInfo).thenAnswer((_) async => mockIosInfo);
      when(mockIosInfo.identifierForVendor).thenReturn('ios-id-456');

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.iOS);
      final expected = sha256.convert(utf8.encode('ios-id-456')).toString().substring(0, 36);

      expect(id, expected);
    });

    test('returns hashed systemGUID on macOS', () async {
      final mockMacInfo = MockMacOsDeviceInfo();
      when(mockDeviceInfoPlugin.macOsInfo).thenAnswer((_) async => mockMacInfo);
      when(mockMacInfo.systemGUID).thenReturn('macos-id-789');

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.macOS);
      final expected = sha256.convert(utf8.encode('macos-id-789')).toString().substring(0, 36);

      expect(id, expected);
    });

    test('returns hashed deviceId on Windows', () async {
      final mockWinInfo = MockWindowsDeviceInfo();
      when(mockDeviceInfoPlugin.windowsInfo).thenAnswer((_) async => mockWinInfo);
      when(mockWinInfo.deviceId).thenReturn('windows-id-101');

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.windows);
      final expected = sha256.convert(utf8.encode('windows-id-101')).toString().substring(0, 36);

      expect(id, expected);
    });

    test('returns non-empty hashed UUID when deviceId is null or empty', () async {
      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('');

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);

      expect(id, isNotEmpty);
      expect(id.length, lessThanOrEqualTo(36)); // truncated
    });

    test('returns non-empty hashed UUID on exception', () async {
      when(mockDeviceInfoPlugin.androidInfo).thenThrow(Exception('fail'));

      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);

      expect(id, isNotEmpty);
      expect(id.length, lessThanOrEqualTo(36)); // truncated
    });
  });
}
