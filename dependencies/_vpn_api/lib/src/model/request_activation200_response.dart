//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/request_activation200_response_token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_activation200_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestActivation200Response {
  /// Returns a new [RequestActivation200Response] instance.
  RequestActivation200Response({
    required this.id,
    required this.valid,
    this.token,
  });

  @JsonKey(
    name: r'id',
    required: true,
    includeIfNull: false,
  )
  final String id;

  @JsonKey(
    name: r'valid',
    required: true,
    includeIfNull: false,
  )
  final bool valid;

  @JsonKey(
    name: r'token',
    required: false,
    includeIfNull: false,
  )
  final RequestActivation200ResponseToken? token;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestActivation200Response &&
          other.id == id &&
          other.valid == valid &&
          other.token == token;

  @override
  int get hashCode => id.hashCode + valid.hashCode + token.hashCode;

  factory RequestActivation200Response.fromJson(Map<String, dynamic> json) =>
      _$RequestActivation200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestActivation200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
