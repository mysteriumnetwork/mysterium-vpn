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
          limitExceeded: $checkedConvert('limit_exceeded', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'wgConfig': 'wg_config', 'limitExceeded': 'limit_exceeded'},
    );

Map<String, dynamic> _$WireguardConnectResponseToJson(WireguardConnectResponse instance) {
  final val = <String, dynamic>{
    'wg_config': instance.wgConfig,
    'hash': instance.hash,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('limit_exceeded', instance.limitExceeded);
  return val;
}
