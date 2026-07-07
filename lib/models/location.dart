import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart';

part 'location.freezed.dart';

part 'location.g.dart';

@freezed
abstract class VPNLocations with _$VPNLocations {
  factory VPNLocations({
    @Default([]) List<VPNLocation> locations,
    @Default([]) List<VPNLocation> topLocations,
  }) = _VPNLocations;

  VPNLocations._();

  factory VPNLocations.fromJson(Map<String, dynamic> json) => _$VPNLocationsFromJson(json);

  @override
  late final Set<VPNLocation> allLocations = {...locations, ...topLocations};
  @override
  late final Set<VPNLocation> allLocationsFlattened = allLocations
      .flattenBy((it) => it.children ?? const <VPNLocation>[])
      .toSet();
  @override
  late final bool isEmpty = allLocations.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

@Freezed(equal: false)
abstract class VPNLocation with _$VPNLocation {
  const factory VPNLocation({
    required String id,
    required IPType ipType,
    required Map<String, String> translations,
    required String countryCode,
    @LatLngConverter() LatLng? coordinates,
    List<VPNLocation>? children,
    int? nodeCount,
    @Default(true) bool isAvailable,
  }) = _VPNLocation;

  const VPNLocation._();

  factory VPNLocation.fromJson(Map<String, dynamic> json) =>
      _$VPNLocationFromJson(_processRawJson(json));

  /// Builds a location from a persisted country code (recent locations). The
  /// country name isn't stored — it's translated at display time from [id] via
  /// the view layer (see `VPNLocationExtensions.getName`).
  factory VPNLocation.fromCode(String code, [IPType ipType = IPType.residential]) =>
      VPNLocation(id: code, ipType: ipType, translations: const {}, countryCode: code);

  factory VPNLocation.fromAPICountry(ConnectionLocation response, {required IPType ipType}) =>
      VPNLocation(
        id: response.country,
        ipType: ipType,
        translations: response.translations,
        nodeCount: response.total.toInt(),
        children: response.cities
            .map((it) => VPNLocation.fromAPICity(it, response.country, ipType))
            .toList(),
        countryCode: response.country,
        isAvailable: response.isAvailable ?? true,
      );

  factory VPNLocation.fromAPICity(ConnectionLocationCity response, String country, IPType ipType) {
    LatLng? coordinates;
    if (response.latitude != null && response.longitude != null) {
      coordinates = LatLng(response.latitude!.toDouble(), response.longitude!.toDouble());
    }
    return VPNLocation(
      id: response.city,
      ipType: ipType,
      translations: response.translations,
      nodeCount: response.total.toInt(),
      countryCode: country,
      coordinates: coordinates,
      isAvailable: response.isAvailable ?? true,
    );
  }

  static const closest = VPNLocation(
    id: '',
    translations: {},
    ipType: IPType.closest,
    countryCode: '',
  );

  /// A location is a country (rather than a city) when its id equals its
  /// country code.
  bool get isCountry => id == countryCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is VPNLocation &&
        other.id == id &&
        other.ipType == ipType &&
        other.countryCode == countryCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode ^ ipType.hashCode ^ countryCode.hashCode;
}

Map<String, dynamic> _processRawJson(Map<String, dynamic> raw) {
  final id = (raw['id'] ?? raw['code']) as String;
  final code = (raw['code'] ?? id) as String;
  final countryCode = (raw['countryCode'] ?? code) as String;

  var translations = raw['translations'];
  if (translations is! Map) {
    translations = <String, String>{
      for (final locale in supportedLocales) locale.languageCode.toLowerCase(): code,
    };
  }
  return {...raw, 'id': id, 'code': code, 'countryCode': countryCode, 'translations': translations};
}
