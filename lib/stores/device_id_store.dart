import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';

part 'device_id_store.g.dart';

// ignore: library_private_types_in_public_api
class DeviceIDStore = _DeviceIDStore with _$DeviceIDStore;

abstract class _DeviceIDStore with Store {
  _DeviceIDStore() {
    deviceIdFuture = ObservableFuture(_getDeviceId());
  }

  final SecureStorageService _secureStorageService = SecureStorageService.instance;

  @observable
  late ObservableFuture<String> deviceIdFuture;

  @action
  Future<String> _getDeviceId() async {
    try {
      var deviceId = await _secureStorageService.getDeviceId();
      if (deviceId == null) {
        deviceId = await FlutterUdid.consistentUdid;
        await _secureStorageService.saveDeviceId(deviceId);
      }
      return deviceId;
    } catch (e) {
      final deviceId = await getDeviceIdFromDeviceInfo();
      await _secureStorageService.saveDeviceId(deviceId);
      return deviceId;
    }
  }

  Future<String> getDeviceIdFromDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      String? deviceId;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfoPlugin.macOsInfo;
        deviceId = macInfo.systemGUID;
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceId = windowsInfo.deviceId;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceId = linuxInfo.machineId;
      }
      if (deviceId == null || deviceId.isEmpty) {
        return '';
      }
      final bytes = utf8.encode(deviceId);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      return '';
    }
  }
}
