import 'dart:io';

import 'package:mysterium_vpn/common/constants/constants.dart';

enum Flavor {
  dev('DEV'),
  production('PROD');

  const Flavor(this.name);

  final String name;
}

class FlavorValues {
  FlavorValues({
    required this.baseUrl,
    required this.scheme,
    required this.webAppUrl,
    required this.sentryDsn,
    required this.billingPage,
    required this.accountName,
  });

  factory FlavorValues.production() => FlavorValues(
        baseUrl: 'https://app.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'app.mysteriumvpn.com',
        sentryDsn: 'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn',
      );
  factory FlavorValues.dev() => FlavorValues(
        baseUrl: 'https://api-test.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'app-testnet.mysteriumvpn.com',
        sentryDsn: 'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app-testnet.mysteriumvpn.com/dashboard/billing',
        accountName: 'mysterium_vpn_test',
      );

  final String baseUrl;
  final String scheme;
  final String webAppUrl;
  final String sentryDsn;
  final String billingPage;
  final String accountName;
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

  String getBundleId() {
    if (Platform.isIOS || Platform.isMacOS) {
      return isDev() ? iosTestBundleId : iosBundleId;
    }
    return isDev() ? testBundleId : bundleId;
  }
}
