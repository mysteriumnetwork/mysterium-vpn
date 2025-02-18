// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_config_request_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionConfigRequestQuery _$ConnectionConfigRequestQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionConfigRequestQuery',
      json,
      ($checkedConvert) {
        final val = ConnectionConfigRequestQuery(
          ipType: $checkedConvert('ip_type',
              (v) => $enumDecodeNullable(_$ConnectionConfigRequestQueryIpTypeEnumEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'ipType': 'ip_type'},
    );

Map<String, dynamic> _$ConnectionConfigRequestQueryToJson(ConnectionConfigRequestQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ip_type', _$ConnectionConfigRequestQueryIpTypeEnumEnumMap[instance.ipType]);
  return val;
}

const _$ConnectionConfigRequestQueryIpTypeEnumEnumMap = {
  ConnectionConfigRequestQueryIpTypeEnum.empty: '',
  ConnectionConfigRequestQueryIpTypeEnum.hosting: 'hosting',
  ConnectionConfigRequestQueryIpTypeEnum.residential: 'residential',
};
