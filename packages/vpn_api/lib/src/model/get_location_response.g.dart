// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetLocationResponse _$GetLocationResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'GetLocationResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['country'],
        );
        final val = GetLocationResponse(
          country: $checkedConvert('country', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$GetLocationResponseToJson(GetLocationResponse instance) => <String, dynamic>{
      'country': instance.country,
    };
