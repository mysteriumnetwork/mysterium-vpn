// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request_one_of.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequestOneOf _$OAuth2TokenRequestOneOfFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenRequestOneOf',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['grant_type', 'client_id', 'refresh_token'],
        );
        final val = OAuth2TokenRequestOneOf(
          grantType: $checkedConvert(
              'grant_type', (v) => $enumDecode(_$OAuth2TokenRequestOneOfGrantTypeEnumEnumMap, v)),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$OAuth2TokenRequestOneOfClientIdEnumEnumMap, v)),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'grantType': 'grant_type',
        'clientId': 'client_id',
        'refreshToken': 'refresh_token'
      },
    );

Map<String, dynamic> _$OAuth2TokenRequestOneOfToJson(OAuth2TokenRequestOneOf instance) =>
    <String, dynamic>{
      'grant_type': _$OAuth2TokenRequestOneOfGrantTypeEnumEnumMap[instance.grantType]!,
      'client_id': _$OAuth2TokenRequestOneOfClientIdEnumEnumMap[instance.clientId]!,
      'refresh_token': instance.refreshToken,
    };

const _$OAuth2TokenRequestOneOfGrantTypeEnumEnumMap = {
  OAuth2TokenRequestOneOfGrantTypeEnum.refreshToken: 'refresh_token',
};

const _$OAuth2TokenRequestOneOfClientIdEnumEnumMap = {
  OAuth2TokenRequestOneOfClientIdEnum.web: 'web',
  OAuth2TokenRequestOneOfClientIdEnum.app: 'app',
  OAuth2TokenRequestOneOfClientIdEnum.extension_: 'extension',
};
