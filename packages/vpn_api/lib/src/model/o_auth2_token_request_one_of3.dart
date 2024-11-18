//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/o_auth2_token_request_one_of3_authorization.dart';
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request_one_of3.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequestOneOf3 {
  /// Returns a new [OAuth2TokenRequestOneOf3] instance.
  OAuth2TokenRequestOneOf3({
    required this.grantType,
    required this.authorization,
  });

  @JsonKey(
    name: r'grant_type',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf3GrantTypeEnum grantType;

  @JsonKey(
    name: r'authorization',
    required: true,
    includeIfNull: false,
  )
  final OAuth2TokenRequestOneOf3Authorization authorization;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequestOneOf3 &&
          other.grantType == grantType &&
          other.authorization == authorization;

  @override
  int get hashCode => grantType.hashCode + authorization.hashCode;

  factory OAuth2TokenRequestOneOf3.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestOneOf3FromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestOneOf3ToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum OAuth2TokenRequestOneOf3GrantTypeEnum {
  @JsonValue(r'apple')
  apple(r'apple');

  const OAuth2TokenRequestOneOf3GrantTypeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
