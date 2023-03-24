enum Flavor { dev, production }

class FlavorValues {
  FlavorValues({required this.baseUrl, required this.scheme, required this.webAppUrl});

  factory FlavorValues.production() => FlavorValues(
        baseUrl: 'https://app.mysteriumvpn.com/api/v1',
        scheme: 'mysteriumvpn',
        webAppUrl: 'https://app-testnet.mysteriumvpn.com',
      );
  factory FlavorValues.dev() => FlavorValues(
        baseUrl: 'https://app-testnet.mysteriumvpn.com/api/v1',
        scheme: 'mysteriumvpn',
        webAppUrl: 'https://app-testnet.mysteriumvpn.com',
      );

  final String baseUrl;
  final String scheme;
  final String webAppUrl;
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
