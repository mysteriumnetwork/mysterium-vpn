// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_locations_request_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionLocationsRequestQuery _$ConnectionLocationsRequestQueryFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionLocationsRequestQuery',
      json,
      ($checkedConvert) {
        final val = ConnectionLocationsRequestQuery(
          ipType: $checkedConvert('ip_type',
              (v) => $enumDecodeNullable(_$ConnectionLocationsRequestQueryIpTypeEnumEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'ipType': 'ip_type'},
    );

Map<String, dynamic> _$ConnectionLocationsRequestQueryToJson(
    ConnectionLocationsRequestQuery instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ip_type', _$ConnectionLocationsRequestQueryIpTypeEnumEnumMap[instance.ipType]);
  return val;
}

const _$ConnectionLocationsRequestQueryIpTypeEnumEnumMap = {
  ConnectionLocationsRequestQueryIpTypeEnum.empty: '',
  ConnectionLocationsRequestQueryIpTypeEnum.hosting: 'hosting',
  ConnectionLocationsRequestQueryIpTypeEnum.residential: 'residential',
};
