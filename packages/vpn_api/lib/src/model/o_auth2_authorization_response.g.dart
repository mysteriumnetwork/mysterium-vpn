// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_authorization_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2AuthorizationResponse _$OAuth2AuthorizationResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2AuthorizationResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['code'],
        );
        final val = OAuth2AuthorizationResponse(
          code: $checkedConvert('code', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$OAuth2AuthorizationResponseToJson(OAuth2AuthorizationResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
    };
