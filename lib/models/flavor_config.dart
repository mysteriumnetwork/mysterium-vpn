enum Flavor { dev, production }

class FlavorValues {
  FlavorValues({
    required this.baseUrl,
    required this.scheme,
    required this.webAppUrl,
    required this.sentryDsn,
    required this.testEmail,
  });

  factory FlavorValues.production() => FlavorValues(
        baseUrl: 'https://app.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'https://app.mysteriumvpn.com/login?scheme=mysteriumvpn',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        testEmail: 'Yet7ej38fcBf3pzrE6xK.S3xFjgNn8rRzrkmLoag8@mysteriumvpn.com',
      );
  factory FlavorValues.dev() => FlavorValues(
        baseUrl: 'https://app-testnet.mysteriumvpn.com/api/v1',
        scheme: 'app',
        webAppUrl: 'https://app-testnet.mysteriumvpn.com/login?scheme=mysteriumvpn',
        sentryDsn:
            'https://62d0b0c708d8492ca4921472bd99ebec@o136129.ingest.sentry.io/4504949838643200',
        testEmail: 'ttcdELfiaq8sgA4D6Y8A.iMC9Y5QyDLrxJnr5cXXC@mysteriumvpn.com',
      );

  final String baseUrl;
  final String scheme;
  final String webAppUrl;
  final String sentryDsn;
  final String testEmail;
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
