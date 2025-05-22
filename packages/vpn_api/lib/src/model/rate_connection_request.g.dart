// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_connection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateConnectionRequest _$RateConnectionRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'RateConnectionRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['country', 'ip_type', 'public_key', 'mode'],
        );
        final val = RateConnectionRequest(
          country: $checkedConvert('country', (v) => v as String),
          ipType: $checkedConvert('ip_type', (v) => v as String),
          publicKey: $checkedConvert('public_key', (v) => v as String),
          feedback: $checkedConvert('feedback', (v) => v as String?),
          reasons: $checkedConvert('reasons', (v) => v as String? ?? ''),
          mode: $checkedConvert(
              'mode', (v) => $enumDecode(_$RateConnectionRequestModeEnumEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'ipType': 'ip_type', 'publicKey': 'public_key'},
    );

Map<String, dynamic> _$RateConnectionRequestToJson(RateConnectionRequest instance) {
  final val = <String, dynamic>{
    'country': instance.country,
    'ip_type': instance.ipType,
    'public_key': instance.publicKey,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('feedback', instance.feedback);
  writeNotNull('reasons', instance.reasons);
  val['mode'] = _$RateConnectionRequestModeEnumEnumMap[instance.mode]!;
  return val;
}

const _$RateConnectionRequestModeEnumEnumMap = {
  RateConnectionRequestModeEnum.like: 'like',
  RateConnectionRequestModeEnum.dislike: 'dislike',
};
