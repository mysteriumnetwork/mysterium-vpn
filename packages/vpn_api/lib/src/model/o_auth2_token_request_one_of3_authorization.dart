//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_request_one_of3_authorization.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenRequestOneOf3Authorization {
  /// Returns a new [OAuth2TokenRequestOneOf3Authorization] instance.
  OAuth2TokenRequestOneOf3Authorization({
    required this.idToken,
  });

  @JsonKey(
    name: r'id_token',
    required: true,
    includeIfNull: false,
  )
  final String idToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenRequestOneOf3Authorization && other.idToken == idToken;

  @override
  int get hashCode => idToken.hashCode;

  factory OAuth2TokenRequestOneOf3Authorization.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenRequestOneOf3AuthorizationFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenRequestOneOf3AuthorizationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
