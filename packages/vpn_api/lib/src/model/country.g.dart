// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Country',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['name', 'code', 'rate'],
        );
        final val = Country(
          name: $checkedConvert('name', (v) => v as String),
          code: $checkedConvert('code', (v) => v as String),
          rate: $checkedConvert('rate', (v) => v as String),
          states: $checkedConvert(
              'states',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => LocationRate.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CountryToJson(Country instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'code': instance.code,
    'rate': instance.rate,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('states', instance.states?.map((e) => e.toJson()).toList());
  return val;
}
