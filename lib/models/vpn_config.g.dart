// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VpnConfigImpl _$$VpnConfigImplFromJson(Map<String, dynamic> json) => _$VpnConfigImpl(
      config: json['wg_config'] as String,
      limitExceeded: json['limit_exceeded'] as bool,
      hashValue: json['hash'] as String,
    );

Map<String, dynamic> _$$VpnConfigImplToJson(_$VpnConfigImpl instance) => <String, dynamic>{
      'wg_config': instance.config,
      'limit_exceeded': instance.limitExceeded,
      'hash': instance.hashValue,
    };

_$VpnConfigInputImpl _$$VpnConfigInputImplFromJson(Map<String, dynamic> json) =>
    _$VpnConfigInputImpl(
      publicKey: json['public_key'] as String,
      resetConnection: json['reset_connection'] as bool,
      osType: json['os_type'] as String,
      country: json['country'] as String?,
      ipType: json['ip_type'] as String?,
    );

Map<String, dynamic> _$$VpnConfigInputImplToJson(_$VpnConfigInputImpl instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'reset_connection': instance.resetConnection,
      'os_type': instance.osType,
      'country': instance.country,
      'ip_type': instance.ipType,
    };
