// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthcheck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthcheckResponse _$HealthcheckResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'HealthcheckResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['status', 'version', 'sha'],
        );
        final val = HealthcheckResponse(
          status: $checkedConvert('status', (v) => v as String),
          version: $checkedConvert('version', (v) => v as String),
          sha: $checkedConvert('sha', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$HealthcheckResponseToJson(HealthcheckResponse instance) => <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'sha': instance.sha,
    };
