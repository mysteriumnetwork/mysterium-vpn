//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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
    required this.ip,
    required this.country,
  });

  @JsonKey(
    name: r'ip',
    required: true,
    includeIfNull: false,
  )
  final String ip;

  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionLocation && other.ip == ip && other.country == country;

  @override
  int get hashCode => ip.hashCode + country.hashCode;

  factory ConnectionLocation.fromJson(Map<String, dynamic> json) =>
      _$ConnectionLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
