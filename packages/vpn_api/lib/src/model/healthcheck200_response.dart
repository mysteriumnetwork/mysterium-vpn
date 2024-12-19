//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'healthcheck200_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Healthcheck200Response {
  /// Returns a new [Healthcheck200Response] instance.
  Healthcheck200Response({
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
      other is Healthcheck200Response &&
          other.status == status &&
          other.version == version &&
          other.sha == sha;

  @override
  int get hashCode => status.hashCode + version.hashCode + sha.hashCode;

  factory Healthcheck200Response.fromJson(Map<String, dynamic> json) =>
      _$Healthcheck200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$Healthcheck200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
