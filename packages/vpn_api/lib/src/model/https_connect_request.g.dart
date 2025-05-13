// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'https_connect_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpsConnectRequest _$HttpsConnectRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'HttpsConnectRequest',
      json,
      ($checkedConvert) {
        final val = HttpsConnectRequest(
          countryOriginate: $checkedConvert('country_originate', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
          ipType: $checkedConvert('ip_type', (v) => v as String?),
          resetConnection: $checkedConvert('reset_connection', (v) => v as bool?),
          osType: $checkedConvert('os_type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'countryOriginate': 'country_originate',
        'ipType': 'ip_type',
        'resetConnection': 'reset_connection',
        'osType': 'os_type'
      },
    );

Map<String, dynamic> _$HttpsConnectRequestToJson(HttpsConnectRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('country_originate', instance.countryOriginate);
  writeNotNull('country', instance.country);
  writeNotNull('ip_type', instance.ipType);
  writeNotNull('reset_connection', instance.resetConnection);
  writeNotNull('os_type', instance.osType);
  return val;
}
