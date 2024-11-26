//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'magic_link_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MagicLinkRequest {
  /// Returns a new [MagicLinkRequest] instance.
  MagicLinkRequest({
    required this.email,
    required this.clientId,
    required this.codeChallenge,
    required this.codeChallengeMethod,
    this.continueTo,
  });

  @JsonKey(
    name: r'email',
    required: true,
    includeIfNull: false,
  )
  final String email;

  @JsonKey(
    name: r'client_id',
    required: true,
    includeIfNull: false,
  )
  final MagicLinkRequestClientIdEnum clientId;

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
  final MagicLinkRequestCodeChallengeMethodEnum codeChallengeMethod;

  /// User will be continue to this path upon authentication
  @JsonKey(
    name: r'continue_to',
    required: false,
    includeIfNull: false,
  )
  final String? continueTo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicLinkRequest &&
          other.email == email &&
          other.clientId == clientId &&
          other.codeChallenge == codeChallenge &&
          other.codeChallengeMethod == codeChallengeMethod &&
          other.continueTo == continueTo;

  @override
  int get hashCode =>
      email.hashCode +
      clientId.hashCode +
      codeChallenge.hashCode +
      codeChallengeMethod.hashCode +
      (continueTo == null ? 0 : continueTo.hashCode);

  factory MagicLinkRequest.fromJson(Map<String, dynamic> json) => _$MagicLinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MagicLinkRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum MagicLinkRequestClientIdEnum {
  @JsonValue(r'web')
  web(r'web'),
  @JsonValue(r'app')
  app(r'app'),
  @JsonValue(r'extension')
  extension_(r'extension');

  const MagicLinkRequestClientIdEnum(this.value);

  final String value;

  @override
  String toString() => value;
}

enum MagicLinkRequestCodeChallengeMethodEnum {
  @JsonValue(r'plain')
  plain(r'plain'),
  @JsonValue(r'S256')
  s256(r'S256'),
  @JsonValue(r's256')
  s2562(r's256');

  const MagicLinkRequestCodeChallengeMethodEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
