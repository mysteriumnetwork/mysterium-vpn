// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationRate _$LocationRateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'LocationRate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['name', 'code', 'rate'],
        );
        final val = LocationRate(
          name: $checkedConvert('name', (v) => v as String),
          code: $checkedConvert('code', (v) => v as String),
          rate: $checkedConvert('rate', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$LocationRateToJson(LocationRate instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'rate': instance.rate,
    };
