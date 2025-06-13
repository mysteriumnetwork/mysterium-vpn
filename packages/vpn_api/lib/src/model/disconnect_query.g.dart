// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disconnect_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisconnectQuery _$DisconnectQueryFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DisconnectQuery',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['public_key'],
        );
        final val = DisconnectQuery(
          publicKey: $checkedConvert('public_key', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'publicKey': 'public_key'},
    );

Map<String, dynamic> _$DisconnectQueryToJson(DisconnectQuery instance) => <String, dynamic>{
      'public_key': instance.publicKey,
    };
