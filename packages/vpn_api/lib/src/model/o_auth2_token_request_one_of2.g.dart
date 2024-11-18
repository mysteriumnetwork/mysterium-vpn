// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request_one_of2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequestOneOf2 _$OAuth2TokenRequestOneOf2FromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenRequestOneOf2',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['grant_type'],
        );
        final val = OAuth2TokenRequestOneOf2(
          grantType: $checkedConvert(
              'grant_type', (v) => $enumDecode(_$OAuth2TokenRequestOneOf2GrantTypeEnumEnumMap, v)),
          code: $checkedConvert('code', (v) => v as String?),
          googleIdToken: $checkedConvert('google_id_token', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'grantType': 'grant_type', 'googleIdToken': 'google_id_token'},
    );

Map<String, dynamic> _$OAuth2TokenRequestOneOf2ToJson(OAuth2TokenRequestOneOf2 instance) {
  final val = <String, dynamic>{
    'grant_type': _$OAuth2TokenRequestOneOf2GrantTypeEnumEnumMap[instance.grantType]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('google_id_token', instance.googleIdToken);
  return val;
}

const _$OAuth2TokenRequestOneOf2GrantTypeEnumEnumMap = {
  OAuth2TokenRequestOneOf2GrantTypeEnum.google: 'google',
};
