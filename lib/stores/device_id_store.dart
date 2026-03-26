import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'device_id_store.g.dart';

// ignore: library_private_types_in_public_api
class DeviceIDStore = _DeviceIDStore with _$DeviceIDStore;

abstract class _DeviceIDStore with Store {
  _DeviceIDStore({
    SecureStorageService? secureStorageService,
    DeviceInfoPlugin? deviceInfoPlugin,
    Future<String> Function()? flutterUdid,
  }) : _secureStorageService = secureStorageService ?? SecureStorageService.instance,
       _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
       _flutterUdid = flutterUdid {
    deviceIdFuture = ObservableFuture(getDeviceId());
  }

  final SecureStorageService _secureStorageService;
  final DeviceInfoPlugin _deviceInfoPlugin;
  Future<String> Function()? _flutterUdid;

  static final _sha256TruncatedRegex = RegExp(r'^[a-f0-9]{36}$');

  @observable
  late ObservableFuture<String> deviceIdFuture;

  @action
  Future<String> getDeviceId() async {
    try {
      var deviceId = await _getDeviceIdFromStorage();
      if (!isSha256Digest(deviceId)) {
        // Makes the function testable by allowing injection of FlutterUdid
        _flutterUdid ??= () => FlutterUdid.udid;
        deviceId = await _flutterUdid!();
        deviceId = _generateSha256(deviceId);
        await _saveDeviceId(deviceId);
      }
      return deviceId!;
    } catch (e) {
      final deviceId = await getDeviceIdFromDeviceInfo();
      await _saveDeviceId(deviceId);
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': defaultTargetPlatform.name,
          'hint': 'Failed to get device ID from device info',
        }),
      );
      return deviceId;
    }
  }

  /// Check if the provided deviceId is a valid truncated SHA-256 digest
  bool isSha256Digest(String? deviceId) {
    if (deviceId == null || deviceId.isEmpty) {
      return false;
    }
    return _sha256TruncatedRegex.hasMatch(deviceId);
  }

  Future<void> _saveDeviceId(String deviceId) async {
    try {
      await _secureStorageService.saveDeviceId(deviceId);
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': defaultTargetPlatform.name,
          'hint': 'Failed to save device ID',
        }),
      );
    }
  }

  Future<String?> _getDeviceIdFromStorage() async {
    try {
      return await _secureStorageService.getDeviceId();
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': defaultTargetPlatform.name,
          'hint': 'Failed to retrieve device ID from storage',
        }),
      );
    }
    return null;
  }

  @computed
  String get deviceId => deviceIdFuture.value ?? '';

  Future<String> getDeviceIdFromDeviceInfo({TargetPlatform? platform}) async {
    try {
      final currentPlatform = platform ?? defaultTargetPlatform;
      String? deviceId;
      switch (currentPlatform) {
        case TargetPlatform.android:
          final androidInfo = await _deviceInfoPlugin.androidInfo;
          deviceId = androidInfo.id;
          break;
        case TargetPlatform.iOS:
          final iosInfo = await _deviceInfoPlugin.iosInfo;
          deviceId = iosInfo.identifierForVendor;
          break;
        case TargetPlatform.macOS:
          final macOsInfo = await _deviceInfoPlugin.macOsInfo;
          deviceId = macOsInfo.systemGUID;
          break;
        case TargetPlatform.windows:
          final windowsInfo = await _deviceInfoPlugin.windowsInfo;
          deviceId = windowsInfo.deviceId;
          break;
        default:
          // For other platforms, we can return an empty string or handle accordingly
          deviceId = null;
      }
      return _generateSha256(deviceId);
    } catch (e) {
      Sentry.captureException(
        e,
        stackTrace: StackTrace.current,
        hint: Hint.withMap({
          'platform': platform?.name ?? 'unknown',
          'hint': 'Failed to get device ID from device info',
        }),
      );
      return _generateSha256(null);
    }
  }

  String _generateSha256(String? deviceId) {
    final id = (deviceId == null || deviceId.isEmpty) ? generateUuidV4() : deviceId;
    final digest = sha256.convert(utf8.encode(id)).toString();
    return digest.substring(0, 36);
  }
}
