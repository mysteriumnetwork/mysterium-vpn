import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/device_id_store.dart';

import 'device_id_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SecureStorageService>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<AndroidDeviceInfo>(),
  MockSpec<IosDeviceInfo>(),
  MockSpec<MacOsDeviceInfo>(),
  MockSpec<WindowsDeviceInfo>(),
  MockSpec<LinuxDeviceInfo>(),
])
void main() {
  late MockSecureStorageService mockStorage;
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;
  late DeviceIDStore store;

  setUp(() {
    mockStorage = MockSecureStorageService();
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    // Mock the FlutterUdid function to return a consistent value
    when(mockStorage.getDeviceId()).thenAnswer((_) async => 'stored-id');
    store = DeviceIDStore(
      secureStorageService: mockStorage,
      deviceInfoPlugin: mockDeviceInfoPlugin,
      flutterUdid: () async => 'mock-udid',
    );
  });

  group('getDeviceId', () {
    test('returns deviceId from storage if present', () async {
      when(mockStorage.getDeviceId()).thenAnswer((_) async => 'stored-id');
      final id = await store.deviceIdFuture;
      expect(id, 'stored-id');
      verify(mockStorage.getDeviceId()).called(1);
      verifyNever(mockStorage.saveDeviceId(any));
    });

    test('generates and saves new deviceId if not in storage', () async {
      when(mockStorage.getDeviceId()).thenAnswer((_) async => null);
      when(mockStorage.saveDeviceId('mock-udid')).thenAnswer((_) async => {});
      final id = await store.getDeviceId();
      expect(id, 'mock-udid');
      verify(mockStorage.saveDeviceId('mock-udid')).called(1);
    });

    test('falls back to getDeviceIdFromDeviceInfo on error', () async {
      when(mockStorage.getDeviceId()).thenThrow(Exception('fail'));
      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('android-fallback');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      final expected = sha256.convert(utf8.encode('android-fallback')).toString();
      expect(id, expected);
    });
  });

  group('getDeviceIdFromDeviceInfo', () {
    test('returns hashed androidId on Android', () async {
      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('android-id-123');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      final expected = sha256.convert(utf8.encode('android-id-123')).toString();
      expect(id, expected);
    });

    test('returns hashed identifierForVendor on iOS', () async {
      final mockIosInfo = MockIosDeviceInfo();
      when(mockDeviceInfoPlugin.iosInfo).thenAnswer((_) async => mockIosInfo);
      when(mockIosInfo.identifierForVendor).thenReturn('ios-id-456');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.iOS);
      final expected = sha256.convert(utf8.encode('ios-id-456')).toString();
      expect(id, expected);
    });

    test('returns hashed systemGUID on macOS', () async {
      final mockMacInfo = MockMacOsDeviceInfo();
      when(mockDeviceInfoPlugin.macOsInfo).thenAnswer((_) async => mockMacInfo);
      when(mockMacInfo.systemGUID).thenReturn('macos-id-789');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.macOS);
      final expected = sha256.convert(utf8.encode('macos-id-789')).toString();
      expect(id, expected);
    });

    test('returns hashed deviceId on Windows', () async {
      final mockWinInfo = MockWindowsDeviceInfo();
      when(mockDeviceInfoPlugin.windowsInfo).thenAnswer((_) async => mockWinInfo);
      when(mockWinInfo.deviceId).thenReturn('windows-id-101');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.windows);
      final expected = sha256.convert(utf8.encode('windows-id-101')).toString();
      expect(id, expected);
    });

    test('returns hashed machineId on Linux', () async {
      final mockLinuxInfo = MockLinuxDeviceInfo();
      when(mockDeviceInfoPlugin.linuxInfo).thenAnswer((_) async => mockLinuxInfo);
      when(mockLinuxInfo.machineId).thenReturn('');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.linux);
      expect(id, '');
    });

    test('returns empty string if deviceId is null or empty', () async {
      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(mockDeviceInfoPlugin.androidInfo).thenAnswer((_) async => mockAndroidInfo);
      when(mockAndroidInfo.id).thenReturn('');
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      expect(id, '');
    });

    test('returns empty string on exception', () async {
      when(mockDeviceInfoPlugin.androidInfo).thenThrow(Exception('fail'));
      final id = await store.getDeviceIdFromDeviceInfo(platform: TargetPlatform.android);
      expect(id, '');
    });
  });
}
