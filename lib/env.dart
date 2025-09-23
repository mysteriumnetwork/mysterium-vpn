import 'dart:io';

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
  static const String billingPage = String.fromEnvironment('BILLING_PAGE');
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

  static final String bundleId = _getBundleId();
  static final Flavor flavor = Flavor.fromEnvironment();

  static late final PackageInfo _packageInfo;
  static BuildInfo _buildInfo = BuildInfo(buildNumber: 0, buildVersion: '0.0.0');
  static late final String _userAgent;

  static PackageInfo get packageInfo => _packageInfo;

  static BuildInfo get buildInfo => _buildInfo;

  static String get userAgent => _userAgent;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
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

  static String stringify() =>
      'baseUrl: $baseUrl, webAppUrl: $webAppUrl, sentryDsn: $sentryDsn, billingPage: $billingPage, accountName: $accountName, appName: $appName, appleClientId: $appleClientId, appleRedirectUri: $appleRedirectUri, tunnelName: $tunnelName, remoteConfigSdkKey: $remoteConfigSdkKey, abTestingSdkKey: $abTestingSdkKey, textsSdkKey: $textsSdkKey, measurementId: $measurementId, apiSecret: $apiSecret, isAutomated: $isAutomated';

  static String _getBundleId() {
    if (Platform.isIOS || Platform.isMacOS) {
      return flavor.isDev ? iosTestBundleId : iosBundleId;
    }
    return flavor.isDev ? testAndroidBundleId : androidBundleId;
  }
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
