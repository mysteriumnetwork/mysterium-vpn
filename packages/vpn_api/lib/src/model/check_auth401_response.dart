//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/check_auth401_response_error.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_auth401_response.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CheckAuth401Response {
  /// Returns a new [CheckAuth401Response] instance.
  CheckAuth401Response({
    this.status,
    this.path,
    required this.error,
  });

  @JsonKey(
    name: r'status',
    required: false,
    includeIfNull: false,
  )
  final int? status;

  @JsonKey(
    name: r'path',
    required: false,
    includeIfNull: false,
  )
  final String? path;

  @JsonKey(
    name: r'error',
    required: true,
    includeIfNull: false,
  )
  final CheckAuth401ResponseError error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckAuth401Response &&
          other.status == status &&
          other.path == path &&
          other.error == error;

  @override
  int get hashCode =>
      (status == null ? 0 : status.hashCode) + (path == null ? 0 : path.hashCode) + error.hashCode;

  factory CheckAuth401Response.fromJson(Map<String, dynamic> json) =>
      _$CheckAuth401ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckAuth401ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
