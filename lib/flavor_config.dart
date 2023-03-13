enum Flavor { dev, production }

class FlavorValues {
  FlavorValues({required this.baseUrl});

  factory FlavorValues.production() => FlavorValues(baseUrl: '');
  factory FlavorValues.dev() => FlavorValues(baseUrl: '');

  final String baseUrl;
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
    FlavorValues(baseUrl: 'https://api.mysterium.network/v1'),
  );

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance ?? _default;

  static bool isProduction() => instance.flavor == Flavor.production;

  static bool isTest() => instance.flavor == Flavor.dev;
}
