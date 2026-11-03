import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

IosDeviceInfo _iosInfo({bool onMac = false, bool onVision = false}) => IosDeviceInfo.fromMap({
  'name': 'iPhone',
  'systemName': 'iOS',
  'systemVersion': '18.0',
  'model': 'iPhone',
  'modelName': 'iPhone 15',
  'localizedModel': 'iPhone',
  'identifierForVendor': 'id',
  'freeDiskSize': 0,
  'totalDiskSize': 0,
  'isPhysicalDevice': true,
  'physicalRamSize': 0,
  'availableRamSize': 0,
  'isiOSAppOnMac': onMac,
  'isiOSAppOnVision': onVision,
  'utsname': <String, dynamic>{
    'sysname': 'Darwin',
    'nodename': 'node',
    'release': '24.0.0',
    'version': 'v',
    'machine': 'arm64',
  },
});

void main() {
  group('isIosAppOnOtherHost', () {
    test('is true for an iOS build running on an Apple Silicon Mac', () {
      expect(isIosAppOnOtherHost(_iosInfo(onMac: true)), isTrue);
    });

    test('is true for an iOS build running on Vision Pro', () {
      expect(isIosAppOnOtherHost(_iosInfo(onVision: true)), isTrue);
    });

    test('is false on a real iPhone', () {
      expect(isIosAppOnOtherHost(_iosInfo()), isFalse);
    });

    test('is false for a non-iOS device', () {
      expect(isIosAppOnOtherHost(BaseDeviceInfo(const {})), isFalse);
    });
  });
}
