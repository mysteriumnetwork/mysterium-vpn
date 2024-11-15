// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_connect_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxyConnectResponse _$ProxyConnectResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ProxyConnectResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['proxy_config'],
        );
        final val = ProxyConnectResponse(
          proxyConfig: $checkedConvert('proxy_config',
              (v) => ProxyConnectResponseProxyConfig.fromJson(v as Map<String, dynamic>)),
          limitExceeded: $checkedConvert('limit_exceeded', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'proxyConfig': 'proxy_config', 'limitExceeded': 'limit_exceeded'},
    );

Map<String, dynamic> _$ProxyConnectResponseToJson(ProxyConnectResponse instance) {
  final val = <String, dynamic>{
    'proxy_config': instance.proxyConfig.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('limit_exceeded', instance.limitExceeded);
  return val;
}
