// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request_one_of3_authorization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequestOneOf3Authorization _$OAuth2TokenRequestOneOf3AuthorizationFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenRequestOneOf3Authorization',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id_token'],
        );
        final val = OAuth2TokenRequestOneOf3Authorization(
          idToken: $checkedConvert('id_token', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'idToken': 'id_token'},
    );

Map<String, dynamic> _$OAuth2TokenRequestOneOf3AuthorizationToJson(
        OAuth2TokenRequestOneOf3Authorization instance) =>
    <String, dynamic>{
      'id_token': instance.idToken,
    };
