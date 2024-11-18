//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/o_auth2_token_request_one_of2.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of3.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of1.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of3_authorization.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of.dart';
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequest {
  /// Returns a new [OAuth2TokenRequest] instance.
  OAuth2TokenRequest({
    required this.grantType,
    required this.clientId,
    required this.refreshToken,
    required this.codeVerifier,
    required this.code,
    this.googleIdToken,
    required this.authorization,
  });

  @JsonKey(
    name: r'grant_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestGrantTypeEnum grantType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestClientIdEnum clientId;

  @JsonKey(
    name: r'refresh_token',
    required: true,
    includeIfNull: false,
  )
  final String refreshToken;

  @JsonKey(
    name: r'code_verifier',
    required: true,
    includeIfNull: false,
  )
  final String codeVerifier;

  /// Google authorization code for retrieving access token
  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: true,
  )
  final String? code;

  /// Google access token. Required if authorization code is not provided.
  @JsonKey(
    name: r'google_id_token',
    required: false,
    includeIfNull: false,
  )
  final String? googleIdToken;

  @JsonKey(
    name: r'authorization',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf3Authorization authorization;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequest &&
          other.grantType == grantType &&
          other.clientId == clientId &&
          other.refreshToken == refreshToken &&
          other.codeVerifier == codeVerifier &&
          other.code == code &&
          other.googleIdToken == googleIdToken &&
          other.authorization == authorization;

  @override
  int get hashCode =>
      grantType.hashCode +
      clientId.hashCode +
      refreshToken.hashCode +
      codeVerifier.hashCode +
      (code == null ? 0 : code.hashCode) +
      (googleIdToken == null ? 0 : googleIdToken.hashCode) +
      authorization.hashCode;

  factory OAuth2TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenRequestGrantTypeEnum {
  @JsonValue(r'apple')
  apple(r'apple');

  const OAuth2TokenRequestGrantTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum OAuth2TokenRequestClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const OAuth2TokenRequestClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
