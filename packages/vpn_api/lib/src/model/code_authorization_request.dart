//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'code_authorization_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CodeAuthorizationRequest {
  /// Returns a new [CodeAuthorizationRequest] instance.
  CodeAuthorizationRequest({
    required this.responseType,
    required this.clientId,
    required this.codeChallenge,
    required this.codeChallengeMethod,
  });

  @JsonKey(
    name: r'response_type',
    required: true,
    includeIfNull: false,
  )
  final CodeAuthorizationRequestResponseTypeEnum responseType;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final CodeAuthorizationRequestClientIdEnum clientId;

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
  final CodeAuthorizationRequestCodeChallengeMethodEnum codeChallengeMethod;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeAuthorizationRequest &&
          other.responseType == responseType &&
          other.clientId == clientId &&
          other.codeChallenge == codeChallenge &&
          other.codeChallengeMethod == codeChallengeMethod;

  @override
  int get hashCode =>
      responseType.hashCode +
      clientId.hashCode +
      codeChallenge.hashCode +
      codeChallengeMethod.hashCode;

  factory CodeAuthorizationRequest.fromJson(Map<String, dynamic> json) =>
      _$CodeAuthorizationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CodeAuthorizationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum CodeAuthorizationRequestResponseTypeEnum {
  @JsonValue(r'code')
  code(r'code');

  const CodeAuthorizationRequestResponseTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum CodeAuthorizationRequestClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const CodeAuthorizationRequestClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum CodeAuthorizationRequestCodeChallengeMethodEnum {
  @JsonValue(r'plain')
  plain(r'plain'),
  @JsonValue(r'S256')
  s256(r'S256'),
  @JsonValue(r's256')
  s2562(r's256');

  const CodeAuthorizationRequestCodeChallengeMethodEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
