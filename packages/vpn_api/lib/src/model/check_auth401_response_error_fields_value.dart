//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'check_auth401_response_error_fields_value.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CheckAuth401ResponseErrorFieldsValue {
  /// Returns a new [CheckAuth401ResponseErrorFieldsValue] instance.
  CheckAuth401ResponseErrorFieldsValue({
    required this.code,
    required this.message,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckAuth401ResponseErrorFieldsValue &&
          other.code == code &&
          other.message == message;

  @override
  int get hashCode => code.hashCode + message.hashCode;

  factory CheckAuth401ResponseErrorFieldsValue.fromJson(Map<String, dynamic> json) =>
      _$CheckAuth401ResponseErrorFieldsValueFromJson(json);

  Map<String, dynamic> toJson() => _$CheckAuth401ResponseErrorFieldsValueToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
