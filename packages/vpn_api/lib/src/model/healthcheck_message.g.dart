// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthcheck_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthcheckMessage _$HealthcheckMessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'HealthcheckMessage',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['status', 'version', 'sha'],
        );
        final val = HealthcheckMessage(
          status: $checkedConvert('status', (v) => v as String),
          version: $checkedConvert('version', (v) => v as String),
          sha: $checkedConvert('sha', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$HealthcheckMessageToJson(HealthcheckMessage instance) => <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'sha': instance.sha,
    };
