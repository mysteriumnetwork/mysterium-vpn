// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_killed_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionKilledMessage _$ConnectionKilledMessageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionKilledMessage',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['reason'],
        );
        final val = ConnectionKilledMessage(
          reason: $checkedConvert(
              'reason', (v) => $enumDecode(_$ConnectionKilledMessageReasonEnumEnumMap, v)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ConnectionKilledMessageToJson(ConnectionKilledMessage instance) =>
    <String, dynamic>{
      'reason': _$ConnectionKilledMessageReasonEnumEnumMap[instance.reason]!,
    };

const _$ConnectionKilledMessageReasonEnumEnumMap = {
  ConnectionKilledMessageReasonEnum.disconnectAll: 'disconnect_all',
  ConnectionKilledMessageReasonEnum.connectionLimit: 'connection_limit',
};
