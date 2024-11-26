//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_introspection_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenIntrospectionResponse {
  /// Returns a new [OAuth2TokenIntrospectionResponse] instance.
  OAuth2TokenIntrospectionResponse({
    required this.active,
    this.username,
    this.sub,
    this.exp,
  });

  /// Boolean indicator of whether or not the presented token is currently active
  @JsonKey(
    name: r'active',
    required: true,
    includeIfNull: false,
  )
  final bool active;

  /// Username (e-mail) associated with the presented token
  @JsonKey(
    name: r'username',
    required: false,
    includeIfNull: false,
  )
  final String? username;

  /// User ID
  @JsonKey(
    name: r'sub',
    required: false,
    includeIfNull: false,
  )
  final String? sub;

  /// Integer timestamp, measured in the number of seconds since January 1 1970 UTC, indicating when this token will expire, as defined in JWT
  @JsonKey(
    name: r'exp',
    required: false,
    includeIfNull: false,
  )
  final num? exp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenIntrospectionResponse &&
          other.active == active &&
          other.username == username &&
          other.sub == sub &&
          other.exp == exp;

  @override
  int get hashCode =>
      active.hashCode +
      (username == null ? 0 : username.hashCode) +
      (sub == null ? 0 : sub.hashCode) +
      (exp == null ? 0 : exp.hashCode);

  factory OAuth2TokenIntrospectionResponse.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenIntrospectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenIntrospectionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
