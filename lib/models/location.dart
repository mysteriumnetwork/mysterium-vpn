import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/ip_type.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/converters/lat_lng_converter.dart';

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

  Set<VPNLocation> get allLocations => {...locations, ...topLocations};
  Set<VPNLocation> get allLocationsFlattened =>
      allLocations.flattenBy((it) => it.children ?? const <VPNLocation>[]).toSet();
  bool get isEmpty => allLocations.isEmpty;

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
  }) = _VPNLocation;

  const VPNLocation._();

  factory VPNLocation.fromJson(Map<String, dynamic> json) =>
      _$VPNLocationFromJson(_processRawJson(json));

  factory VPNLocation.fromCode(String code, [IPType ipType = IPType.residential]) {
    List<Locale> locales;
    locales = kSupportedLocales;
    final translations = {
      for (final locale in locales) locale.languageCode.toLowerCase(): code.tr(),
    };
    return VPNLocation(
      id: code,
      ipType: ipType,
      translations: translations,
      countryCode: code,
    );
  }

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
      for (final locale in kSupportedLocales) locale.languageCode.toLowerCase(): code,
    };
  }
  return {
    ...raw,
    'id': id,
    'code': code,
    'countryCode': countryCode,
    'translations': translations,
  };
}
