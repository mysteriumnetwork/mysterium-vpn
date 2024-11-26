//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'location_rate.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationRate {
  /// Returns a new [LocationRate] instance.
  LocationRate({
    required this.name,
    required this.code,
    required this.rate,
  });

  @JsonKey(
    name: r'name',
    required: true,
    includeIfNull: false,
  )
  final String name;

  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: false,
  )
  final String code;

  @JsonKey(
    name: r'rate',
    required: true,
    includeIfNull: false,
  )
  final String rate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationRate && other.name == name && other.code == code && other.rate == rate;

  @override
  int get hashCode => name.hashCode + code.hashCode + rate.hashCode;

  factory LocationRate.fromJson(Map<String, dynamic> json) => _$LocationRateFromJson(json);

  Map<String, dynamic> toJson() => _$LocationRateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
