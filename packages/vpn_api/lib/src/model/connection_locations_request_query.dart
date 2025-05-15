//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_locations_request_query.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionLocationsRequestQuery {
  /// Returns a new [ConnectionLocationsRequestQuery] instance.
  ConnectionLocationsRequestQuery({
    this.ipType,
  });

  @JsonKey(
    name: r'ip_type',
    required: false,
    includeIfNull: false,
  )
  final ConnectionLocationsRequestQueryIpTypeEnum? ipType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConnectionLocationsRequestQuery && other.ipType == ipType;

  @override
  int get hashCode => (ipType == null ? 0 : ipType.hashCode);

  factory ConnectionLocationsRequestQuery.fromJson(Map<String, dynamic> json) =>
      _$ConnectionLocationsRequestQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionLocationsRequestQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ConnectionLocationsRequestQueryIpTypeEnum {
  @JsonValue(r'')
  empty(r''),
  @JsonValue(r'hosting')
  hosting(r'hosting'),
  @JsonValue(r'residential')
  residential(r'residential');

  const ConnectionLocationsRequestQueryIpTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
