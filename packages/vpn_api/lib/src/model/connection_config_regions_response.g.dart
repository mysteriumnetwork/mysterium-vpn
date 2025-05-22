// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_config_regions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionConfigRegionsResponse _$ConnectionConfigRegionsResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionConfigRegionsResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['regions'],
        );
        final val = ConnectionConfigRegionsResponse(
          regions: $checkedConvert(
              'regions',
              (v) => (v as List<dynamic>)
                  .map((e) => ConnectionRegion.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ConnectionConfigRegionsResponseToJson(
        ConnectionConfigRegionsResponse instance) =>
    <String, dynamic>{
      'regions': instance.regions.map((e) => e.toJson()).toList(),
    };
