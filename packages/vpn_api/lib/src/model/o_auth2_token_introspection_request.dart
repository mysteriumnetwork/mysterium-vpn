//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'o_auth2_token_introspection_request.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OAuth2TokenIntrospectionRequest {
  /// Returns a new [OAuth2TokenIntrospectionRequest] instance.
  OAuth2TokenIntrospectionRequest({
    this.token,
  });

  /// Token to be introspected. Optional when token is presented via Authorization header.
  @JsonKey(
    name: r'token',
    required: false,
    includeIfNull: false,
  )
  final String? token;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OAuth2TokenIntrospectionRequest && other.token == token;

  @override
  int get hashCode => (token == null ? 0 : token.hashCode);

  factory OAuth2TokenIntrospectionRequest.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenIntrospectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OAuth2TokenIntrospectionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
