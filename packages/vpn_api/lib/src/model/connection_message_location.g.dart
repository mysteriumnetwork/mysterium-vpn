// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_message_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionMessageLocation _$ConnectionMessageLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionMessageLocation',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['ip', 'country', 'node_type'],
        );
        final val = ConnectionMessageLocation(
          ip: $checkedConvert('ip', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          nodeType: $checkedConvert('node_type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'nodeType': 'node_type'},
    );

Map<String, dynamic> _$ConnectionMessageLocationToJson(ConnectionMessageLocation instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'country': instance.country,
      'node_type': instance.nodeType,
    };
