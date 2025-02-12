// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionLocation _$ConnectionLocationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ConnectionLocation',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['ip', 'country', 'node_type'],
        );
        final val = ConnectionLocation(
          ip: $checkedConvert('ip', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          nodeType: $checkedConvert('node_type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'nodeType': 'node_type'},
    );

Map<String, dynamic> _$ConnectionLocationToJson(ConnectionLocation instance) => <String, dynamic>{
      'ip': instance.ip,
      'country': instance.country,
      'node_type': instance.nodeType,
    };
