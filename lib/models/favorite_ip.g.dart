// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_ip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteIp _$FavoriteIpFromJson(Map<String, dynamic> json) => _FavoriteIp(
  ip: json['ip'] as String,
  countryCode: json['countryCode'] as String,
  city: json['city'] as String,
  ipType: $enumDecode(_$IPTypeEnumMap, json['ipType']),
  savedAt: DateTime.parse(json['savedAt'] as String),
  countryName: json['countryName'] as String? ?? '',
  locationId: json['locationId'] as String? ?? '',
);

Map<String, dynamic> _$FavoriteIpToJson(_FavoriteIp instance) => <String, dynamic>{
  'ip': instance.ip,
  'countryCode': instance.countryCode,
  'city': instance.city,
  'ipType': _$IPTypeEnumMap[instance.ipType]!,
  'savedAt': instance.savedAt.toIso8601String(),
  'countryName': instance.countryName,
  'locationId': instance.locationId,
};

const _$IPTypeEnumMap = {
  IPType.residential: 'residential',
  IPType.datacenter: 'datacenter',
  IPType.closest: 'closest',
};
