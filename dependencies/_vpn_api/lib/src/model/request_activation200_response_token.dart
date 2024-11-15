//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'request_activation200_response_token.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestActivation200ResponseToken {
  /// Returns a new [RequestActivation200ResponseToken] instance.
  RequestActivation200ResponseToken({
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
  final RequestActivation200ResponseTokenTokenTypeEnum tokenType;

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
      other is RequestActivation200ResponseToken &&
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

  factory RequestActivation200ResponseToken.fromJson(Map<String, dynamic> json) =>
      _$RequestActivation200ResponseTokenFromJson(json);

  Map<String, dynamic> toJson() => _$RequestActivation200ResponseTokenToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum RequestActivation200ResponseTokenTokenTypeEnum {
  @JsonValue(r'bearer')
  bearer(r'bearer');

  const RequestActivation200ResponseTokenTokenTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
