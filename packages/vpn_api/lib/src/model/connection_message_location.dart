//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_message_location.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionMessageLocation {
  /// Returns a new [ConnectionMessageLocation] instance.
  ConnectionMessageLocation({
    required this.ip,
    required this.country,
    required this.nodeType,
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

  @JsonKey(
    name: r'node_type',
    required: true,
    includeIfNull: false,
  )
  final String nodeType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionMessageLocation &&
          other.ip == ip &&
          other.country == country &&
          other.nodeType == nodeType;

  @override
  int get hashCode => ip.hashCode + country.hashCode + nodeType.hashCode;

  factory ConnectionMessageLocation.fromJson(Map<String, dynamic> json) =>
      _$ConnectionMessageLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionMessageLocationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
