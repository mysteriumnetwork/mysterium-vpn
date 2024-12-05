// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_connect_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireguardConnectResponse _$WireguardConnectResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WireguardConnectResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['wg_config', 'hash'],
        );
        final val = WireguardConnectResponse(
          wgConfig: $checkedConvert('wg_config', (v) => v as String),
          hash: $checkedConvert('hash', (v) => v as String),
          exitIp: $checkedConvert('exit_ip', (v) => v as String?),
          limitExceeded: $checkedConvert('limit_exceeded', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'wgConfig': 'wg_config',
        'exitIp': 'exit_ip',
        'limitExceeded': 'limit_exceeded'
      },
    );

Map<String, dynamic> _$WireguardConnectResponseToJson(WireguardConnectResponse instance) =>
    <String, dynamic>{
      'wg_config': instance.wgConfig,
      'hash': instance.hash,
      if (instance.exitIp case final value?) 'exit_ip': value,
      if (instance.limitExceeded case final value?) 'limit_exceeded': value,
    };
