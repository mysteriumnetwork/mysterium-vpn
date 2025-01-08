// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionMessage _$ConnectionMessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ConnectionMessage',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['location'],
        );
        final val = ConnectionMessage(
          location: $checkedConvert(
              'location', (v) => ConnectionMessageLocation.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ConnectionMessageToJson(ConnectionMessage instance) => <String, dynamic>{
      'location': instance.location.toJson(),
    };
