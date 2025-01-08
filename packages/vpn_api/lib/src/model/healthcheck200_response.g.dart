// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthcheck200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Healthcheck200Response _$Healthcheck200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Healthcheck200Response',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['status', 'version', 'sha'],
        );
        final val = Healthcheck200Response(
          status: $checkedConvert('status', (v) => v as String),
          version: $checkedConvert('version', (v) => v as String),
          sha: $checkedConvert('sha', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$Healthcheck200ResponseToJson(Healthcheck200Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'sha': instance.sha,
    };
