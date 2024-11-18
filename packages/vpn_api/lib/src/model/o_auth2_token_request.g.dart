// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenRequest _$OAuth2TokenRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OAuth2TokenRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'grant_type',
            'client_id',
            'refresh_token',
            'code_verifier',
            'code',
            'authorization'
          ],
        );
        final val = OAuth2TokenRequest(
          grantType: $checkedConvert(
              'grant_type', (v) => $enumDecode(_$OAuth2TokenRequestGrantTypeEnumEnumMap, v)),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$OAuth2TokenRequestClientIdEnumEnumMap, v)),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
          codeVerifier: $checkedConvert('code_verifier', (v) => v as String),
          code: $checkedConvert('code', (v) => v as String?),
          googleIdToken: $checkedConvert('google_id_token', (v) => v as String?),
          authorization: $checkedConvert('authorization',
              (v) => OAuth2TokenRequestOneOf3Authorization.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'grantType': 'grant_type',
        'clientId': 'client_id',
        'refreshToken': 'refresh_token',
        'codeVerifier': 'code_verifier',
        'googleIdToken': 'google_id_token'
      },
    );

Map<String, dynamic> _$OAuth2TokenRequestToJson(OAuth2TokenRequest instance) {
  final val = <String, dynamic>{
    'grant_type': _$OAuth2TokenRequestGrantTypeEnumEnumMap[instance.grantType]!,
    'client_id': _$OAuth2TokenRequestClientIdEnumEnumMap[instance.clientId]!,
    'refresh_token': instance.refreshToken,
    'code_verifier': instance.codeVerifier,
    'code': instance.code,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('google_id_token', instance.googleIdToken);
  val['authorization'] = instance.authorization.toJson();
  return val;
}

const _$OAuth2TokenRequestGrantTypeEnumEnumMap = {
  OAuth2TokenRequestGrantTypeEnum.apple: 'apple',
};

const _$OAuth2TokenRequestClientIdEnumEnumMap = {
  OAuth2TokenRequestClientIdEnum.web: 'web',
  OAuth2TokenRequestClientIdEnum.app: 'app',
  OAuth2TokenRequestClientIdEnum.extension_: 'extension',
};
