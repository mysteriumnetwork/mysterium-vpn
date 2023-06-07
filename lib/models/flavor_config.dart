enum Flavor { dev, production }

class FlavorValues {
  FlavorValues({
    required this.baseUrl,
    required this.scheme,
    required this.webAppUrl,
    required this.sentryDsn,
    required this.billingPage,
  });

  factory FlavorValues.production() => FlavorValues(
        baseUrl: 'https://app.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'app.mysteriumvpn.com',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app.mysteriumvpn.com/dashboard/billing',
      );
  factory FlavorValues.dev() => FlavorValues(
        baseUrl: 'https://api-test.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'app-testnet.mysteriumvpn.com',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        billingPage: 'https://app-testnet.mysteriumvpn.com/dashboard/billing',
      );

  final String baseUrl;
  final String scheme;
  final String webAppUrl;
  final String sentryDsn;
  final String billingPage;
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      values,
    );
    return _instance!;
  }
  FlavorConfig._internal(this.flavor, this.values);
  final Flavor flavor;

  final FlavorValues values;

  static final FlavorConfig _default = FlavorConfig._internal(
    Flavor.production,
    FlavorValues.production(),
  );

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance ?? _default;

  static bool isProduction() => instance.flavor == Flavor.production;

  static bool isDev() => instance.flavor == Flavor.dev;
}
