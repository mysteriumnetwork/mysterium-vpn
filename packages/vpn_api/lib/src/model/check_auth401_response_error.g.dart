// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_auth401_response_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckAuth401ResponseError _$CheckAuth401ResponseErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CheckAuth401ResponseError',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['code', 'message'],
        );
        final val = CheckAuth401ResponseError(
          code: $checkedConvert('code', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          detail: $checkedConvert('detail', (v) => v as String?),
          fields: $checkedConvert(
              'fields',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k,
                        CheckAuth401ResponseErrorFieldsValue.fromJson(e as Map<String, dynamic>)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$CheckAuth401ResponseErrorToJson(CheckAuth401ResponseError instance) {
  final val = <String, dynamic>{
    'code': instance.code,
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('detail', instance.detail);
  writeNotNull('fields', instance.fields?.map((k, e) => MapEntry(k, e.toJson())));
  return val;
}
