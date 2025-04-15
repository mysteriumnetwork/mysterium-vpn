// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VPNLocationsImpl _$$VPNLocationsImplFromJson(Map<String, dynamic> json) => _$VPNLocationsImpl(
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => VPNLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topLocations: (json['topLocations'] as List<dynamic>?)
              ?.map((e) => VPNLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$VPNLocationsImplToJson(_$VPNLocationsImpl instance) => <String, dynamic>{
      'locations': instance.locations,
      'topLocations': instance.topLocations,
    };

_$VPNLocationImpl _$$VPNLocationImplFromJson(Map<String, dynamic> json) => _$VPNLocationImpl(
      code: json['code'] as String,
      ipType: $enumDecodeNullable(_$IPTypeEnumMap, json['ipType']) ?? IPType.residential,
    );

Map<String, dynamic> _$$VPNLocationImplToJson(_$VPNLocationImpl instance) => <String, dynamic>{
      'code': instance.code,
      'ipType': _$IPTypeEnumMap[instance.ipType]!,
    };

const _$IPTypeEnumMap = {
  IPType.residential: 'residential',
  IPType.datacenter: 'datacenter',
};
