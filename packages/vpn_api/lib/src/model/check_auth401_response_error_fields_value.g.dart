// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_auth401_response_error_fields_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckAuth401ResponseErrorFieldsValue _$CheckAuth401ResponseErrorFieldsValueFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CheckAuth401ResponseErrorFieldsValue',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['code', 'message'],
        );
        final val = CheckAuth401ResponseErrorFieldsValue(
          code: $checkedConvert('code', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CheckAuth401ResponseErrorFieldsValueToJson(
        CheckAuth401ResponseErrorFieldsValue instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
