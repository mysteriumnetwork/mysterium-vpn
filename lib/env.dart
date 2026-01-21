import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_checker_windows/store_checker_windows.dart';

abstract class Env {
  const Env._();

  static const String baseUrl = String.fromEnvironment('BASE_URL');
  static const String mqttUrl = String.fromEnvironment('MQTT_URL');
  static const String mqttUsername = String.fromEnvironment('MQTT_USERNAME');
  static const String mqttPassword = String.fromEnvironment('MQTT_PASSWORD');
  static const String webAppUrl = String.fromEnvironment('WEB_APP_URL');
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const String manageSubscriptionPage = String.fromEnvironment('BILLING_PAGE');
  static const String upgradeSubscriptionPage = String.fromEnvironment('UPGRADE_SUBS_PAGE');
  static const String accountName = String.fromEnvironment('ACCOUNT_NAME');
  static const String appName = String.fromEnvironment('APP_NAME');
  static const String appleClientId = String.fromEnvironment('APPLE_CLIENT_ID');
  static const String appleRedirectUri = String.fromEnvironment('APPLE_REDIRECT_URI');
  static const String tunnelName = String.fromEnvironment('TUNNEL_NAME');
  static const String remoteConfigSdkKey = String.fromEnvironment('REMOTE_CONFIG_SDK_KEY');
  static const String abTestingSdkKey = String.fromEnvironment('AB_TESTING_SDK_KEY');
  static const String textsSdkKey = String.fromEnvironment('TEXTS_SDK_KEY');
  static const String measurementId = String.fromEnvironment('MEASUREMENT_ID');
  static const String apiSecret = String.fromEnvironment('API_SECRET');
  static const bool isAutomated = bool.fromEnvironment('IS_AUTOMATED');
  static const String manageDevicesPage = String.fromEnvironment('MANAGE_DEVICES_PAGE');
  static const String appCustomSchemeUrl = String.fromEnvironment('APP_CUSTOM_SCHEME_URL');
  static const String oneSignalAppId = String.fromEnvironment('ONE_SIGNAL_APP_ID');

  static final String bundleId = _getBundleId();
  static final Flavor flavor = Flavor.fromEnvironment();
  static const String openVpnExtensionId = String.fromEnvironment('OPENVPN_EXTENSION_ID');
  static const String openVpnExtensionName = String.fromEnvironment('OPENVPN_EXTENSION_NAME');
  static late final PackageInfo _packageInfo;
  static BuildInfo _buildInfo = BuildInfo(buildNumber: 0, buildVersion: '0.0.0');
  static late final String _userAgent;
  static late final BaseDeviceInfo _deviceInfo;
  static late final String _deviceName;
  static late final String _deviceModel;

  static PackageInfo get packageInfo => _packageInfo;

  static BuildInfo get buildInfo => _buildInfo;

  static BaseDeviceInfo get deviceInfo => _deviceInfo;

  static String get deviceName => _deviceName;

  static String get deviceModel => _deviceModel;

  static String get userAgent => _userAgent;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    await initDeviceInfo();
    _buildInfo = BuildInfo(
      buildNumber: int.tryParse(_packageInfo.buildNumber) ?? 0,
      buildVersion: _packageInfo.version,
      installerStore:
          Platform.isWindows ? getCurrentPackageFullName() : _packageInfo.installerStore,
    );
    _userAgent = [
      Env.appName,
      Platform.operatingSystem,
      _buildInfo.buildVersion,
      '(${_buildInfo.buildNumber})',
    ].join(' ');
  }

  @visibleForTesting
  static Future<void> initDeviceInfo([DeviceInfoPlugin? plugin]) async {
    try {
      plugin ??= DeviceInfoPlugin();
      _deviceInfo = await plugin.deviceInfo;
    } catch (_) {
      // In case of any error, we assign an empty BaseDeviceInfo to avoid null issues.
      // Since we never access things from _deviceInfo without checking its type first,
      // this should be safe. In this case, deviceName and deviceModel will be 'Unknown'.
      _deviceInfo = BaseDeviceInfo({});
    }

    _deviceName = switch (_deviceInfo) {
      final AndroidDeviceInfo android => android.name,
      final IosDeviceInfo iOS => '${iOS.modelName} ${iOS.systemVersion}',
      final MacOsDeviceInfo macOS => macOS.computerName,
      final WindowsDeviceInfo windows => windows.computerName,
      _ => 'Unknown',
    };
    _deviceModel = switch (_deviceInfo) {
      final AndroidDeviceInfo android => android.model,
      final IosDeviceInfo iOS => iOS.model,
      final MacOsDeviceInfo macOS => macOS.model,
      final WindowsDeviceInfo windows => windows.productName,
      _ => 'Unknown',
    };
  }

  static String stringify() =>
      'baseUrl: $baseUrl, webAppUrl: $webAppUrl, sentryDsn: $sentryDsn, manageSubscriptionPage: $manageSubscriptionPage, upgradeSubscriptionPage: $upgradeSubscriptionPage, accountName: $accountName, appName: $appName, appleClientId: $appleClientId, appleRedirectUri: $appleRedirectUri, tunnelName: $tunnelName, remoteConfigSdkKey: $remoteConfigSdkKey, abTestingSdkKey: $abTestingSdkKey, textsSdkKey: $textsSdkKey, measurementId: $measurementId, apiSecret: $apiSecret, isAutomated: $isAutomated, openVpnExtensionId: $openVpnExtensionId, openVpnExtensionName: $openVpnExtensionName, manageDevicesPage: $manageDevicesPage, flavor: ${flavor.name}, oneSignalAppId: $oneSignalAppId';

  static String _getBundleId() {
    if (Platform.isIOS || Platform.isMacOS) {
      return flavor.isDev ? iosTestBundleId : iosBundleId;
    }
    return flavor.isDev ? testAndroidBundleId : androidBundleId;
  }

  static Map<String, String> asMap() => {
        'BASE_URL': baseUrl,
        'MQTT_URL': mqttUrl,
        'MQTT_USERNAME': mqttUsername,
        'MQTT_PASSWORD': mqttPassword,
        'WEB_APP_URL': webAppUrl,
        'SENTRY_DSN': sentryDsn,
        'BILLING_PAGE': manageSubscriptionPage,
        'UPGRADE_SUBS_PAGE': upgradeSubscriptionPage,
        'ACCOUNT_NAME': accountName,
        'APP_NAME': appName,
        'APPLE_CLIENT_ID': appleClientId,
        'APPLE_REDIRECT_URI': appleRedirectUri,
        'TUNNEL_NAME': tunnelName,
        'REMOTE_CONFIG_SDK_KEY': remoteConfigSdkKey,
        'AB_TESTING_SDK_KEY': abTestingSdkKey,
        'TEXTS_SDK_KEY': textsSdkKey,
        'MEASUREMENT_ID': measurementId,
        'API_SECRET': apiSecret,
        'IS_AUTOMATED': isAutomated.toString(),
        'ENV_APP': flavor.name,
        'OPENVPN_EXTENSION_ID': openVpnExtensionId,
        'OPENVPN_EXTENSION_NAME': openVpnExtensionName,
        'MANAGE_DEVICES_PAGE': manageDevicesPage,
        'APP_CUSTOM_SCHEME_URL': appCustomSchemeUrl,
        'ONE_SIGNAL_APP_ID': oneSignalAppId,
      };
}

enum Flavor {
  dev('DEV'),
  production('PROD');

  const Flavor(this.name);

  static Flavor fromEnvironment() {
    const flavor = String.fromEnvironment('ENV_APP');
    return Flavor.values.firstWhere(
      (f) => f.name == flavor,
      orElse: () => Flavor.production,
    );
  }

  final String name;

  bool get isProduction => this == Flavor.production;

  bool get isDev => this == Flavor.dev;
}

class BuildInfo {
  BuildInfo({
    required this.buildNumber,
    required this.buildVersion,
    this.installerStore,
  });

  final int buildNumber;
  final String buildVersion;
  final String? installerStore;

  @override
  String toString() => 'buildNumber: $buildNumber, buildVersion: $buildVersion';
}
