// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthConfigResponse _$AuthConfigResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AuthConfigResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['google_client_id', 'apple_service_id'],
        );
        final val = AuthConfigResponse(
          googleClientId: $checkedConvert('google_client_id', (v) => v as String),
          appleServiceId: $checkedConvert('apple_service_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'googleClientId': 'google_client_id',
        'appleServiceId': 'apple_service_id'
      },
    );

Map<String, dynamic> _$AuthConfigResponseToJson(AuthConfigResponse instance) => <String, dynamic>{
      'google_client_id': instance.googleClientId,
      'apple_service_id': instance.appleServiceId,
    };
