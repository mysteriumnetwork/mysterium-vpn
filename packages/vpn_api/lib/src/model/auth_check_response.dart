//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'auth_check_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuthCheckResponse {
  /// Returns a new [AuthCheckResponse] instance.
  AuthCheckResponse({
    required this.username,
    required this.userId,
  });

  @JsonKey(
    name: r'username',
    required: true,
    includeIfNull: false,
  )
  final String username;

  @JsonKey(
    name: r'user_id',
    required: true,
    includeIfNull: false,
  )
  final String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCheckResponse && other.username == username && other.userId == userId;

  @override
  int get hashCode => username.hashCode + userId.hashCode;

  factory AuthCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCheckResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
