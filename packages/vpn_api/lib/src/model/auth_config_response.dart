//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_config_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthConfigResponse {
  /// Returns a new [AuthConfigResponse] instance.
  AuthConfigResponse({
    required this.googleClientId,
    required this.appleServiceId,
  });

  @JsonKey(
    name: r'google_client_id',
    required: true,
    includeIfNull: false,
  )
  final String googleClientId;

  @JsonKey(
    name: r'apple_service_id',
    required: true,
    includeIfNull: false,
  )
  final String appleServiceId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthConfigResponse &&
          other.googleClientId == googleClientId &&
          other.appleServiceId == appleServiceId;

  @override
  int get hashCode => googleClientId.hashCode + appleServiceId.hashCode;

  factory AuthConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthConfigResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
