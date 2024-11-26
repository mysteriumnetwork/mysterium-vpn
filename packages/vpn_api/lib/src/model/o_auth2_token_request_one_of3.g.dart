// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request_one_of3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequestOneOf3 _$OAuth2TokenRequestOneOf3FromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenRequestOneOf3',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['grant_type', 'authorization'],
        );
        final val = OAuth2TokenRequestOneOf3(
          grantType: $checkedConvert(
              'grant_type', (v) => $enumDecode(_$OAuth2TokenRequestOneOf3GrantTypeEnumEnumMap, v)),
          authorization: $checkedConvert('authorization',
              (v) => OAuth2TokenRequestOneOf3Authorization.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'grantType': 'grant_type'},
    );

Map<String, dynamic> _$OAuth2TokenRequestOneOf3ToJson(OAuth2TokenRequestOneOf3 instance) =>
    <String, dynamic>{
      'grant_type': _$OAuth2TokenRequestOneOf3GrantTypeEnumEnumMap[instance.grantType]!,
      'authorization': instance.authorization.toJson(),
    };

const _$OAuth2TokenRequestOneOf3GrantTypeEnumEnumMap = {
  OAuth2TokenRequestOneOf3GrantTypeEnum.apple: 'apple',
};
