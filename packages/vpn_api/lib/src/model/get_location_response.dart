//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'get_location_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GetLocationResponse {
  /// Returns a new [GetLocationResponse] instance.
  GetLocationResponse({
    required this.country,
  });

  @JsonKey(
    name: r'country',
    required: true,
    includeIfNull: false,
  )
  final String country;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GetLocationResponse && other.country == country;

  @override
  int get hashCode => country.hashCode;

  factory GetLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetLocationResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
