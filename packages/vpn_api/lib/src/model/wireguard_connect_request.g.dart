// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_connect_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireguardConnectRequest _$WireguardConnectRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WireguardConnectRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['public_key'],
        );
        final val = WireguardConnectRequest(
          publicKey: $checkedConvert('public_key', (v) => v as String),
          countryOriginate: $checkedConvert('country_originate', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
          ipType: $checkedConvert('ip_type', (v) => v as String?),
          resetConnection: $checkedConvert('reset_connection', (v) => v as bool?),
          osType: $checkedConvert('os_type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'publicKey': 'public_key',
        'countryOriginate': 'country_originate',
        'ipType': 'ip_type',
        'resetConnection': 'reset_connection',
        'osType': 'os_type'
      },
    );

Map<String, dynamic> _$WireguardConnectRequestToJson(WireguardConnectRequest instance) {
  final val = <String, dynamic>{
    'public_key': instance.publicKey,
  };

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
