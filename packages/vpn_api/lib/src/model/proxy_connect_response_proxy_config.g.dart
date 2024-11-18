// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_connect_response_proxy_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxyConnectResponseProxyConfig _$ProxyConnectResponseProxyConfigFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ProxyConnectResponseProxyConfig',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['host', 'port', 'username', 'password', 'expires_at'],
        );
        final val = ProxyConnectResponseProxyConfig(
          host: $checkedConvert('host', (v) => v as String),
          port: $checkedConvert('port', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          password: $checkedConvert('password', (v) => v as String),
          expiresAt: $checkedConvert('expires_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'expiresAt': 'expires_at'},
    );

Map<String, dynamic> _$ProxyConnectResponseProxyConfigToJson(
        ProxyConnectResponseProxyConfig instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
