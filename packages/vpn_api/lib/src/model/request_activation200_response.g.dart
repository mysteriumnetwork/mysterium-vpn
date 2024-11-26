// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_activation200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestActivation200Response _$RequestActivation200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RequestActivation200Response',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id', 'valid'],
        );
        final val = RequestActivation200Response(
          id: $checkedConvert('id', (v) => v as String),
          valid: $checkedConvert('valid', (v) => v as bool),
          token: $checkedConvert(
              'token',
              (v) => v == null
                  ? null
                  : RequestActivation200ResponseToken.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$RequestActivation200ResponseToJson(RequestActivation200Response instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'valid': instance.valid,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('token', instance.token?.toJson());
  return val;
}
