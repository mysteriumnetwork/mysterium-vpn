//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'healthcheck_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthcheckResponse {
  /// Returns a new [HealthcheckResponse] instance.
  HealthcheckResponse({
    required this.status,
    required this.version,
    required this.sha,
  });

  @JsonKey(
    name: r'status',
    required: true,
    includeIfNull: false,
  )
  final String status;

  @JsonKey(
    name: r'version',
    required: true,
    includeIfNull: false,
  )
  final String version;

  @JsonKey(
    name: r'sha',
    required: true,
    includeIfNull: false,
  )
  final String sha;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthcheckResponse &&
          other.status == status &&
          other.version == version &&
          other.sha == sha;

  @override
  int get hashCode => status.hashCode + version.hashCode + sha.hashCode;

  factory HealthcheckResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthcheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HealthcheckResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
