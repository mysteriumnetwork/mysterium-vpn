//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/connection_location_city.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connection_location.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionLocation {
  /// Returns a new [ConnectionLocation] instance.
  ConnectionLocation({
    required this.country,
    required this.total,
    required this.cities,
    required this.translations,
  });

  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @JsonKey(
    name: r'total',
    required: true,
    includeIfNull: false,
  )
  final num total;

  @JsonKey(
    name: r'cities',
    required: true,
    includeIfNull: false,
  )
  final List<ConnectionLocationCity> cities;

  @JsonKey(
    name: r'translations',
    required: true,
    includeIfNull: false,
  )
  final Map<String, String> translations;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionLocation &&
          other.country == country &&
          other.total == total &&
          other.cities == cities &&
          other.translations == translations;

  @override
  int get hashCode => country.hashCode + total.hashCode + cities.hashCode + translations.hashCode;

  factory ConnectionLocation.fromJson(Map<String, dynamic> json) =>
      _$ConnectionLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
