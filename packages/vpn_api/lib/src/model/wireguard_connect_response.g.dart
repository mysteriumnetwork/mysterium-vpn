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
          requiredKeys: const ['id', 'wg_config', 'hash'],
        );
        final val = WireguardConnectResponse(
          id: $checkedConvert('id', (v) => v as String),
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

Map<String, dynamic> _$WireguardConnectResponseToJson(WireguardConnectResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'wg_config': instance.wgConfig,
    'hash': instance.hash,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('exit_ip', instance.exitIp);
  writeNotNull('limit_exceeded', instance.limitExceeded);
  return val;
}
