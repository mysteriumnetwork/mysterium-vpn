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
      coordinates: _$JsonConverterFromJson<Map<String, dynamic>, LatLng>(
          json['coordinates'], const LatLngConverter().fromJson),
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
      'coordinates': _$JsonConverterToJson<Map<String, dynamic>, LatLng>(
          instance.coordinates, const LatLngConverter().toJson),
      'children': instance.children,
      'nodeCount': instance.nodeCount,
    };

const _$IPTypeEnumMap = {
  IPType.residential: 'residential',
  IPType.datacenter: 'datacenter',
  IPType.closest: 'closest',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
