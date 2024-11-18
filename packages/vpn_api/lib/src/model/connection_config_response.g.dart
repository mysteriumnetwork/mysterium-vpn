// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionConfigResponse _$ConnectionConfigResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionConfigResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['countries', 'top_countries'],
        );
        final val = ConnectionConfigResponse(
          countries: $checkedConvert(
              'countries', (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          topCountries: $checkedConvert(
              'top_countries', (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'topCountries': 'top_countries'},
    );

Map<String, dynamic> _$ConnectionConfigResponseToJson(ConnectionConfigResponse instance) =>
    <String, dynamic>{
      'countries': instance.countries,
      'top_countries': instance.topCountries,
    };
