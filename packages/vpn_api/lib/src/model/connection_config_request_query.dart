//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'connection_config_request_query.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConnectionConfigRequestQuery {
  /// Returns a new [ConnectionConfigRequestQuery] instance.
  ConnectionConfigRequestQuery({
    this.ipType,
  });

  @JsonKey(
    name: r'ip_type',
    required: false,
    includeIfNull: false,
  )
  final ConnectionConfigRequestQueryIpTypeEnum? ipType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ConnectionConfigRequestQuery && other.ipType == ipType;

  @override
  int get hashCode => (ipType == null ? 0 : ipType.hashCode);

  factory ConnectionConfigRequestQuery.fromJson(Map<String, dynamic> json) =>
      _$ConnectionConfigRequestQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionConfigRequestQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ConnectionConfigRequestQueryIpTypeEnum {
  @JsonValue(r'')
  empty(r''),
  @JsonValue(r'hosting')
  hosting(r'hosting'),
  @JsonValue(r'residential')
  residential(r'residential');

  const ConnectionConfigRequestQueryIpTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
