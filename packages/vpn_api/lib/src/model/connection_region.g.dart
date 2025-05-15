// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionRegion _$ConnectionRegionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ConnectionRegion',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id', 'host', 'top_countries'],
        );
        final val = ConnectionRegion(
          id: $checkedConvert('id', (v) => v as String),
          host: $checkedConvert('host', (v) => v as String),
          topCountries: $checkedConvert(
              'top_countries', (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'topCountries': 'top_countries'},
    );

Map<String, dynamic> _$ConnectionRegionToJson(ConnectionRegion instance) => <String, dynamic>{
      'id': instance.id,
      'host': instance.host,
      'top_countries': instance.topCountries,
    };
