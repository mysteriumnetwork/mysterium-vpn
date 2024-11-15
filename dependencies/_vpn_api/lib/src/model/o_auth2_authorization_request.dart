//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/activation_authorization_request.dart';
import 'package:vpn_api/src/model/code_authorization_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_authorization_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2AuthorizationRequest {
  /// Returns a new [OAuth2AuthorizationRequest] instance.
  OAuth2AuthorizationRequest({
    required this.responseType,
    required this.clientId,
    required this.codeChallenge,
    required this.codeChallengeMethod,
    required this.requestId,
  });

  @JsonKey(
    name: r'response_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2AuthorizationRequestResponseTypeEnum responseType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final OAuth2AuthorizationRequestClientIdEnum clientId;

  @JsonKey(
    name: r'code_challenge',
    required: true,
    includeIfNull: false,
  )
  final String codeChallenge;

  @JsonKey(
    name: r'code_challenge_method',
    required: true,
    includeIfNull: false,
  )
  final OAuth2AuthorizationRequestCodeChallengeMethodEnum codeChallengeMethod;

  @JsonKey(
    name: r'request_id',
    required: true,
    includeIfNull: false,
  )
  final String requestId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2AuthorizationRequest &&
          other.responseType == responseType &&
          other.clientId == clientId &&
          other.codeChallenge == codeChallenge &&
          other.codeChallengeMethod == codeChallengeMethod &&
          other.requestId == requestId;

  @override
  int get hashCode =>
      responseType.hashCode +
      clientId.hashCode +
      codeChallenge.hashCode +
      codeChallengeMethod.hashCode +
      requestId.hashCode;

  factory OAuth2AuthorizationRequest.fromJson(Map<String, dynamic> json) =>
      _$OAuth2AuthorizationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2AuthorizationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2AuthorizationRequestResponseTypeEnum {
  @JsonValue(r'activation_none')
  activationNone(r'activation_none');

  const OAuth2AuthorizationRequestResponseTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum OAuth2AuthorizationRequestClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const OAuth2AuthorizationRequestClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum OAuth2AuthorizationRequestCodeChallengeMethodEnum {
  @JsonValue(r'plain')
  plain(r'plain'),
  @JsonValue(r'S256')
  s256(r'S256'),
  @JsonValue(r's256')
  s2562(r's256');

  const OAuth2AuthorizationRequestCodeChallengeMethodEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
