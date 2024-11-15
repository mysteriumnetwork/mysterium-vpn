//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_config_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionConfigResponse {
  /// Returns a new [ConnectionConfigResponse] instance.
  ConnectionConfigResponse({
    required this.countries,
    required this.topCountries,
  });

  @JsonKey(
    name: r'countries',
    required: true,
    includeIfNull: false,
  )
  final List<String> countries;

  @JsonKey(
    name: r'top_countries',
    required: true,
    includeIfNull: false,
  )
  final List<String> topCountries;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionConfigResponse &&
          other.countries == countries &&
          other.topCountries == topCountries;

  @override
  int get hashCode => countries.hashCode + topCountries.hashCode;

  factory ConnectionConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionConfigResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
