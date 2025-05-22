// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_config_regions_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionConfigRegionsQuery _$ConnectionConfigRegionsQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionConfigRegionsQuery',
      json,
      ($checkedConvert) {
        final val = ConnectionConfigRegionsQuery(
          ipType: $checkedConvert('ip_type',
              (v) => $enumDecodeNullable(_$ConnectionConfigRegionsQueryIpTypeEnumEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'ipType': 'ip_type'},
    );

Map<String, dynamic> _$ConnectionConfigRegionsQueryToJson(ConnectionConfigRegionsQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ip_type', _$ConnectionConfigRegionsQueryIpTypeEnumEnumMap[instance.ipType]);
  return val;
}

const _$ConnectionConfigRegionsQueryIpTypeEnumEnumMap = {
  ConnectionConfigRegionsQueryIpTypeEnum.empty: '',
  ConnectionConfigRegionsQueryIpTypeEnum.hosting: 'hosting',
  ConnectionConfigRegionsQueryIpTypeEnum.residential: 'residential',
};
