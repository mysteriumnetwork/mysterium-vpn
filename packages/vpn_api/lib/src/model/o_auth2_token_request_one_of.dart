//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request_one_of.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequestOneOf {
  /// Returns a new [OAuth2TokenRequestOneOf] instance.
  OAuth2TokenRequestOneOf({
    required this.grantType,
    required this.clientId,
    required this.refreshToken,
  });

  @JsonKey(
    name: r'grant_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOfGrantTypeEnum grantType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOfClientIdEnum clientId;

  @JsonKey(
    name: r'refresh_token',
    required: true,
    includeIfNull: false,
  )
  final String refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequestOneOf &&
          other.grantType == grantType &&
          other.clientId == clientId &&
          other.refreshToken == refreshToken;

  @override
  int get hashCode => grantType.hashCode + clientId.hashCode + refreshToken.hashCode;

  factory OAuth2TokenRequestOneOf.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestOneOfFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestOneOfToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenRequestOneOfGrantTypeEnum {
  @JsonValue(r'refresh_token')
  refreshToken(r'refresh_token');

  const OAuth2TokenRequestOneOfGrantTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum OAuth2TokenRequestOneOfClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const OAuth2TokenRequestOneOfClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
