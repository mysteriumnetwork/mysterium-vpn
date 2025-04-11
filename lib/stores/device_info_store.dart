import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'device_info_store.g.dart';

// ignore: library_private_types_in_public_api
class DeviceInfoStore = _DeviceInfoStore with _$DeviceInfoStore;

abstract class _DeviceInfoStore with Store {
  _DeviceInfoStore() {
    deviceInfoFuture = ObservableFuture(_fetch());
  }
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @observable
  late ObservableFuture<Map<String, dynamic>> deviceInfoFuture;

  @computed
  Map<String, dynamic>? get deviceInfo => deviceInfoFuture.value;

  @computed
  String get deviceId => (deviceInfo?.containsKey('id') ?? false) && deviceInfo!['id'] is String
      ? deviceInfo!['id'] as String
      : '';

  @computed
  String get deviceName =>
      (deviceInfo?.containsKey('name') ?? false) && deviceInfo!['name'] is String
          ? deviceInfo!['name'] as String
          : '';

  @computed
  String get deviceModel =>
      (deviceInfo?.containsKey('model') ?? false) && deviceInfo!['model'] is String
          ? deviceInfo!['model'] as String
          : '';

  Future<Map<String, dynamic>> _fetch() async {
    final deviceData = switch (defaultTargetPlatform) {
      TargetPlatform.android => _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
      TargetPlatform.iOS => _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
      TargetPlatform.windows => _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
      TargetPlatform.macOS => _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
      _ => <String, dynamic>{},
    };
    return deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) => <String, dynamic>{
        'name': build.name,
        'id': build.id,
        'model': build.model,
      };

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) => <String, dynamic>{
        'name': data.name,
        'id': data.identifierForVendor,
        'model': data.model,
      };

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) => <String, dynamic>{
        'name': data.computerName,
        'id': data.deviceId,
        'model': data.productName,
      };

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) => <String, dynamic>{
        'name': data.computerName,
        'id': data.systemGUID,
        'model': data.model,
      };
}
