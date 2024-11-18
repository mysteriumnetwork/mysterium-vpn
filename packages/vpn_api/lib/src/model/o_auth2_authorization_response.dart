//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_authorization_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2AuthorizationResponse {
  /// Returns a new [OAuth2AuthorizationResponse] instance.
  OAuth2AuthorizationResponse({
    required this.code,
  });

  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: false,
  )
  final String code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OAuth2AuthorizationResponse && other.code == code;

  @override
  int get hashCode => code.hashCode;

  factory OAuth2AuthorizationResponse.fromJson(Map<String, dynamic> json) =>
      _$OAuth2AuthorizationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2AuthorizationResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
