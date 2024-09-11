import 'package:package_info_plus/package_info_plus.dart';

enum Flavor {
  dev('DEV'),
  production('PROD');

  const Flavor(this.name);

  final String name;
}

class FlavorValues {
  FlavorValues({
    required this.baseUrl,
    required this.webAppUrl,
    required this.sentryDsn,
    required this.billingPage,
    required this.accountName,
    required this.appName,
    required this.appleClientId,
    required this.appleRedirectUri,
    required this.tunnelName,
  });

  factory FlavorValues.production() => FlavorValues(
        baseUrl: 'https://app.mysteriumvpn.com/api/v1',
        webAppUrl: 'app.mysteriumvpn.com',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn',
        appName: 'Mysterium VPN',
        appleClientId: 'com.mysteriumvpn.app',
        appleRedirectUri: 'https://app.mysteriumvpn.com/api/v1/callbacks/apple-sign-in',
        tunnelName: 'MysteriumVPN',
      );
  factory FlavorValues.dev() => FlavorValues(
        baseUrl: 'https://app-testnet.mysteriumvpn.com/api/v1',
        webAppUrl: 'app-testnet.mysteriumvpn.com',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app-testnet.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn_test',
        appName: 'Mysterium VPN Test',
        appleClientId: 'com.mysteriumvpn.app-testnet',
        appleRedirectUri: 'https://app-testnet.mysteriumvpn.com/api/v1/callbacks/apple-sign-in',
        tunnelName: 'MysteriumTest',
      );

  final String baseUrl;
  final String webAppUrl;
  final String sentryDsn;
  final String billingPage;
  final String accountName;
  final String appName;
  final String appleClientId;
  final String appleRedirectUri;
  final String tunnelName;

  @override
  String toString() =>
      'baseUrl: $baseUrl, webAppUrl: $webAppUrl, sentryDsn: $sentryDsn, billingPage: $billingPage, accountName: $accountName, appName: $appName, appleClientId: $appleClientId, appleRedirectUri: $appleRedirectUri, tunnelName: $tunnelName';
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) =>
      FlavorConfig._internal(flavor, values);
  FlavorConfig._internal(this.flavor, this.values);
  final Flavor flavor;

  final FlavorValues values;

  bool isProduction() => flavor == Flavor.production;

  bool isDev() => flavor == Flavor.dev;

  Future<String> getBundleId() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
