//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:vpn_api/src/model/check_auth401_response_error_fields_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_auth401_response_error.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CheckAuth401ResponseError {
  /// Returns a new [CheckAuth401ResponseError] instance.
  CheckAuth401ResponseError({
    required this.code,
    required this.message,
    this.detail,
    this.fields,
  });

  @JsonKey(
    name: r'code',
    required: true,
    includeIfNull: false,
  )
  final String code;

  @JsonKey(
    name: r'message',
    required: true,
    includeIfNull: false,
  )
  final String message;

  @JsonKey(
    name: r'detail',
    required: false,
    includeIfNull: false,
  )
  final String? detail;

  @JsonKey(
    name: r'fields',
    required: false,
    includeIfNull: false,
  )
  final Map<String, CheckAuth401ResponseErrorFieldsValue>? fields;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckAuth401ResponseError &&
          other.code == code &&
          other.message == message &&
          other.detail == detail &&
          other.fields == fields;

  @override
  int get hashCode =>
      code.hashCode +
      message.hashCode +
      (detail == null ? 0 : detail.hashCode) +
      (fields == null ? 0 : fields.hashCode);

  factory CheckAuth401ResponseError.fromJson(Map<String, dynamic> json) =>
      _$CheckAuth401ResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$CheckAuth401ResponseErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
