// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_location_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionLocationCity _$ConnectionLocationCityFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ConnectionLocationCity',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['city', 'total', 'translations'],
        );
        final val = ConnectionLocationCity(
          city: $checkedConvert('city', (v) => v as String),
          total: $checkedConvert('total', (v) => v as num),
          translations: $checkedConvert('translations', (v) => Map<String, String>.from(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ConnectionLocationCityToJson(ConnectionLocationCity instance) =>
    <String, dynamic>{
      'city': instance.city,
      'total': instance.total,
      'translations': instance.translations,
    };
