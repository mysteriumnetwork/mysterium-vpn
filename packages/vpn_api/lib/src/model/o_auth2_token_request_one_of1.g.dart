// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request_one_of1.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequestOneOf1 _$OAuth2TokenRequestOneOf1FromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenRequestOneOf1',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['grant_type', 'client_id', 'code_verifier', 'code'],
        );
        final val = OAuth2TokenRequestOneOf1(
          grantType: $checkedConvert(
              'grant_type', (v) => $enumDecode(_$OAuth2TokenRequestOneOf1GrantTypeEnumEnumMap, v)),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$OAuth2TokenRequestOneOf1ClientIdEnumEnumMap, v)),
          codeVerifier: $checkedConvert('code_verifier', (v) => v as String),
          code: $checkedConvert('code', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'grantType': 'grant_type',
        'clientId': 'client_id',
        'codeVerifier': 'code_verifier'
      },
    );

Map<String, dynamic> _$OAuth2TokenRequestOneOf1ToJson(OAuth2TokenRequestOneOf1 instance) =>
    <String, dynamic>{
      'grant_type': _$OAuth2TokenRequestOneOf1GrantTypeEnumEnumMap[instance.grantType]!,
      'client_id': _$OAuth2TokenRequestOneOf1ClientIdEnumEnumMap[instance.clientId]!,
      'code_verifier': instance.codeVerifier,
      'code': instance.code,
    };

const _$OAuth2TokenRequestOneOf1GrantTypeEnumEnumMap = {
  OAuth2TokenRequestOneOf1GrantTypeEnum.authorizationCode: 'authorization_code',
};

const _$OAuth2TokenRequestOneOf1ClientIdEnumEnumMap = {
  OAuth2TokenRequestOneOf1ClientIdEnum.web: 'web',
  OAuth2TokenRequestOneOf1ClientIdEnum.app: 'app',
  OAuth2TokenRequestOneOf1ClientIdEnum.extension_: 'extension',
};
