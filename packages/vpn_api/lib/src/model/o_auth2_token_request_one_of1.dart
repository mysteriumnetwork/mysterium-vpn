//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request_one_of1.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequestOneOf1 {
  /// Returns a new [OAuth2TokenRequestOneOf1] instance.
  OAuth2TokenRequestOneOf1({
    required this.grantType,
    required this.clientId,
    required this.codeVerifier,
    required this.code,
  });

  @JsonKey(
    name: r'grant_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf1GrantTypeEnum grantType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf1ClientIdEnum clientId;

  @JsonKey(
    name: r'code_verifier',
    required: true,
    includeIfNull: false,
  )
  final String codeVerifier;

  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: false,
  )
  final String code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequestOneOf1 &&
          other.grantType == grantType &&
          other.clientId == clientId &&
          other.codeVerifier == codeVerifier &&
          other.code == code;

  @override
  int get hashCode =>
      grantType.hashCode + clientId.hashCode + codeVerifier.hashCode + code.hashCode;

  factory OAuth2TokenRequestOneOf1.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestOneOf1FromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestOneOf1ToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenRequestOneOf1GrantTypeEnum {
  @JsonValue(r'authorization_code')
  authorizationCode(r'authorization_code');

  const OAuth2TokenRequestOneOf1GrantTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum OAuth2TokenRequestOneOf1ClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const OAuth2TokenRequestOneOf1ClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
