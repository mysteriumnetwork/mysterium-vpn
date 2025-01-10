// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
