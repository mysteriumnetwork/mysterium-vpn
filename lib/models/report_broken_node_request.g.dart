// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_broken_node_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportBrokenNodeRequestImpl _$$ReportBrokenNodeRequestImplFromJson(Map<String, dynamic> json) =>
    _$ReportBrokenNodeRequestImpl(
      publicKey: json['public_key'] as String,
      destinationCountry: json['destination_country'] as String,
      osType: json['os_type'] as String,
      appVersion: json['app_version'] as String,
      hashValue: json['hash'] as String,
      originCountry: json['origin_country'] as String?,
      connectivityType: $enumDecodeNullable(_$ConnectivityResultEnumMap, json['internet_type']),
    );

Map<String, dynamic> _$$ReportBrokenNodeRequestImplToJson(_$ReportBrokenNodeRequestImpl instance) =>
    <String, dynamic>{
      'public_key': instance.publicKey,
      'destination_country': instance.destinationCountry,
      'os_type': instance.osType,
      'app_version': instance.appVersion,
      'hash': instance.hashValue,
      'origin_country': instance.originCountry,
      'internet_type': _$ConnectivityResultEnumMap[instance.connectivityType],
    };

const _$ConnectivityResultEnumMap = {
  ConnectivityResult.bluetooth: 'bluetooth',
  ConnectivityResult.wifi: 'wifi',
  ConnectivityResult.ethernet: 'ethernet',
  ConnectivityResult.mobile: 'mobile',
  ConnectivityResult.none: 'none',
  ConnectivityResult.vpn: 'vpn',
  ConnectivityResult.other: 'other',
};
