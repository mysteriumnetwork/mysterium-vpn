import 'dart:io';

import 'package:mysterium_vpn/common/constants/constants.dart';

enum Flavor {
  dev('DEV'),
  production('PROD');

  const Flavor(this.name);

  final String name;
}

class FlavorValues {
  FlavorValues._({
    required this.baseUrl,
    required this.mqttUrl,
    required this.mqttUsername,
    required this.mqttPassword,
    required this.webAppUrl,
    required this.sentryDsn,
    required this.billingPage,
    required this.accountName,
    required this.appName,
    required this.appleClientId,
    required this.appleRedirectUri,
    required this.tunnelName,
    required this.remoteConfigSdkKey,
    required this.abTestingSdkKey,
    required this.textsSdkKey,
    required this.measurementId,
    required this.apiSecret,
    required this.isAutomated,
  });

  factory FlavorValues.production() => FlavorValues._(
        baseUrl: 'https://api.mysteriumvpn.com/api/v1',
        mqttUrl: 'wss://events.mysteriumvpn.com/ws',
        mqttUsername: 'dvpn',
        mqttPassword: '9LxB25TF8ANFN2bHfpi4',
        webAppUrl: 'app.mysteriumvpn.com',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn',
        appName: 'Mysterium VPN',
        appleClientId: 'com.mysteriumvpn.app',
        appleRedirectUri: 'https://api.mysteriumvpn.com/api/v1/callbacks/apple-sign-in',
        tunnelName: 'MysteriumVPN',
        remoteConfigSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/ZKdEmBGd9EukTUz4fPL6mw',
        abTestingSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/X1h2DjWhpEq7P2KXA2WymA',
        textsSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/ZnfqKRIkCEy2oG4Fc_ZbgA',
        measurementId: 'G-293FMB7WPQ',
        apiSecret: 'An1EAWXDRp6iivNpZ6uKBg',
        isAutomated: false,
      );

  factory FlavorValues.dev({bool isAutomated = const bool.fromEnvironment('IS_AUTOMATED')}) =>
      FlavorValues._(
        baseUrl: 'https://api.test.mysteriumvpn.com/api/v1',
        mqttUrl: 'wss://events.test.mysteriumvpn.com/ws',
        mqttUsername: 'dvpn',
        mqttPassword: 'VWm2UJVV7BYr6p3S8ZZZ',
        webAppUrl: 'app.test.mysteriumvpn.com',
        sentryDsn: 'https://5b2acee54898674711aeba99171db808@sentry.mysterium.network/2',
        billingPage: 'https://app.test.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn_test',
        appName: 'Mysterium VPN Test',
        appleClientId: 'com.mysteriumvpn.app-testnet',
        appleRedirectUri: 'https://api.test.mysteriumvpn.com/api/v1/callbacks/apple-sign-in',
        tunnelName: 'MysteriumTest',
        remoteConfigSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/fEG0yLr3KEed9BjXRuQvgA',
        abTestingSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/_PK9Imkd8EG-w8NiPpc5bw',
        textsSdkKey: 'configcat-sdk-1/4PjcCICjokiFdAeS1Y35vA/OyPvJv7luUW48Kb20B3dbw',
        measurementId: 'G-9Y0P8J42T5',
        apiSecret: 'AIzaSyDEg8yyxnhEaCJ7wBPcOqd6O8W2FTkDJXg',
        isAutomated: isAutomated,
      );

  final String baseUrl;
  final String mqttUrl;
  final String mqttUsername;
  final String mqttPassword;
  final String webAppUrl;
  final String sentryDsn;
  final String billingPage;
  final String accountName;
  final String appName;
  final String appleClientId;
  final String appleRedirectUri;
  final String tunnelName;
  final String remoteConfigSdkKey;
  final String abTestingSdkKey;
  final String textsSdkKey;
  final String measurementId;
  final String apiSecret;
  final bool isAutomated;

  @override
  String toString() =>
      'baseUrl: $baseUrl, webAppUrl: $webAppUrl, sentryDsn: $sentryDsn, billingPage: $billingPage, accountName: $accountName, appName: $appName, appleClientId: $appleClientId, appleRedirectUri: $appleRedirectUri, tunnelName: $tunnelName, remoteConfigSdkKey: $remoteConfigSdkKey, abTestingSdkKey: $abTestingSdkKey, textsSdkKey: $textsSdkKey, measurementId: $measurementId, apiSecret: $apiSecret, isAutomated: $isAutomated';
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
    required BuildInfo buildInfo,
  }) =>
      FlavorConfig._internal(flavor, values, buildInfo);

  FlavorConfig._internal(
    this.flavor,
    this.values,
    this.buildInfo,
  );

  final Flavor flavor;
  final FlavorValues values;
  final BuildInfo buildInfo;

  bool get isProduction => flavor == Flavor.production;

  bool get isDev => flavor == Flavor.dev;

  String getBundleId() {
    if (Platform.isIOS || Platform.isMacOS) {
      return isDev ? iosTestBundleId : iosBundleId;
    }
    return isDev ? testBundleId : bundleId;
  }

  String appUserAgent() =>
      '${values.appName} ${Platform.operatingSystem} ${buildInfo.buildVersion} (${buildInfo.buildNumber})';
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
