// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIError _$APIErrorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'APIError',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['error'],
        );
        final val = APIError(
          status: $checkedConvert('status', (v) => (v as num?)?.toInt()),
          path: $checkedConvert('path', (v) => v as String?),
          error: $checkedConvert(
              'error', (v) => CheckAuth401ResponseError.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$APIErrorToJson(APIError instance) {
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
