//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_config_regions_query.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionConfigRegionsQuery {
  /// Returns a new [ConnectionConfigRegionsQuery] instance.
  ConnectionConfigRegionsQuery({
    this.ipType,
  });

  @JsonKey(
    name: r'ip_type',
    required: false,
    includeIfNull: false,
  )
  final ConnectionConfigRegionsQueryIpTypeEnum? ipType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConnectionConfigRegionsQuery && other.ipType == ipType;

  @override
  int get hashCode => (ipType == null ? 0 : ipType.hashCode);

  factory ConnectionConfigRegionsQuery.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigRegionsQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionConfigRegionsQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ConnectionConfigRegionsQueryIpTypeEnum {
  @JsonValue(r'')
  empty(r''),
  @JsonValue(r'hosting')
  hosting(r'hosting'),
  @JsonValue(r'residential')
  residential(r'residential');

  const ConnectionConfigRegionsQueryIpTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
