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
      id: json['id'] as String,
      ipType: $enumDecode(_$IPTypeEnumMap, json['ipType']),
      translations: Map<String, String>.from(json['translations'] as Map),
      countryCode: json['countryCode'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => VPNLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      nodeCount: (json['nodeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$VPNLocationImplToJson(_$VPNLocationImpl instance) => <String, dynamic>{
      'id': instance.id,
      'ipType': _$IPTypeEnumMap[instance.ipType]!,
      'translations': instance.translations,
      'countryCode': instance.countryCode,
      'children': instance.children,
      'nodeCount': instance.nodeCount,
    };

const _$IPTypeEnumMap = {
  IPType.residential: 'residential',
  IPType.datacenter: 'datacenter',
  IPType.closest: 'closest',
};
