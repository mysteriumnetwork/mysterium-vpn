//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request_one_of2.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequestOneOf2 {
  /// Returns a new [OAuth2TokenRequestOneOf2] instance.
  OAuth2TokenRequestOneOf2({
    required this.grantType,
    this.code,
    this.googleIdToken,
  });

  @JsonKey(
    name: r'grant_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf2GrantTypeEnum grantType;

  /// Google authorization code for retrieving access token
  @JsonKey(
    name: r'code',
    required: false,
    includeIfNull: false,
  )
  final String? code;

  /// Google access token. Required if authorization code is not provided.
  @JsonKey(
    name: r'google_id_token',
    required: false,
    includeIfNull: false,
  )
  final String? googleIdToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequestOneOf2 &&
          other.grantType == grantType &&
          other.code == code &&
          other.googleIdToken == googleIdToken;

  @override
  int get hashCode =>
      grantType.hashCode +
      (code == null ? 0 : code.hashCode) +
      (googleIdToken == null ? 0 : googleIdToken.hashCode);

  factory OAuth2TokenRequestOneOf2.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestOneOf2FromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestOneOf2ToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenRequestOneOf2GrantTypeEnum {
  @JsonValue(r'google')
  google(r'google');

  const OAuth2TokenRequestOneOf2GrantTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
