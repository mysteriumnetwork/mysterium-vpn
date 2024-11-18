// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_auth401_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckAuth401Response _$CheckAuth401ResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'CheckAuth401Response',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['error'],
        );
        final val = CheckAuth401Response(
          status: $checkedConvert('status', (v) => (v as num?)?.toInt()),
          path: $checkedConvert('path', (v) => v as String?),
          error: $checkedConvert(
              'error', (v) => CheckAuth401ResponseError.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$CheckAuth401ResponseToJson(CheckAuth401Response instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('path', instance.path);
  val['error'] = instance.error.toJson();
  return val;
}
