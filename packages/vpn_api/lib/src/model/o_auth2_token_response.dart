//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenResponse {
  /// Returns a new [OAuth2TokenResponse] instance.
  OAuth2TokenResponse({
    required this.accessToken,
    required this.tokenType,
    this.expiresIn,
    this.refreshToken,
    required this.userId,
  });

  @JsonKey(
    name: r'access_token',
    required: true,
    includeIfNull: false,
  )
  final String accessToken;

  @JsonKey(
    name: r'token_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenResponseTokenTypeEnum tokenType;

  @JsonKey(
    name: r'expires_in',
    required: false,
    includeIfNull: false,
  )
  final num? expiresIn;

  @JsonKey(
    name: r'refresh_token',
    required: false,
    includeIfNull: false,
  )
  final String? refreshToken;

  @JsonKey(
    name: r'user_id',
    required: true,
    includeIfNull: false,
  )
  final String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenResponse &&
          other.accessToken == accessToken &&
          other.tokenType == tokenType &&
          other.expiresIn == expiresIn &&
          other.refreshToken == refreshToken &&
          other.userId == userId;

  @override
  int get hashCode =>
      accessToken.hashCode +
      tokenType.hashCode +
      (expiresIn == null ? 0 : expiresIn.hashCode) +
      (refreshToken == null ? 0 : refreshToken.hashCode) +
      userId.hashCode;

  factory OAuth2TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenResponseTokenTypeEnum {
  @JsonValue(r'bearer')
  bearer(r'bearer');

  const OAuth2TokenResponseTokenTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
