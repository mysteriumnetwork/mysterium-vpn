// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'FieldError',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['code', 'message'],
        );
        final val = FieldError(
          code: $checkedConvert('code', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$FieldErrorToJson(FieldError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
