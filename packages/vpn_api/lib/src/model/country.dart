//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/location_rate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Country {
  /// Returns a new [Country] instance.
  Country({
    required this.name,
    required this.code,
    required this.rate,
    this.states,
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

  @JsonKey(
    name: r'states',
    required: false,
    includeIfNull: false,
  )
  final List<LocationRate>? states;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          other.name == name &&
          other.code == code &&
          other.rate == rate &&
          other.states == states;

  @override
  int get hashCode =>
      name.hashCode + code.hashCode + rate.hashCode + (states == null ? 0 : states.hashCode);

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
