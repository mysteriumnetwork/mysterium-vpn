// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenResponse _$OAuth2TokenResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OAuth2TokenResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['access_token', 'token_type', 'user_id'],
        );
        final val = OAuth2TokenResponse(
          accessToken: $checkedConvert('access_token', (v) => v as String),
          tokenType: $checkedConvert(
              'token_type', (v) => $enumDecode(_$OAuth2TokenResponseTokenTypeEnumEnumMap, v)),
          expiresIn: $checkedConvert('expires_in', (v) => v as num?),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String?),
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'tokenType': 'token_type',
        'expiresIn': 'expires_in',
        'refreshToken': 'refresh_token',
        'userId': 'user_id'
      },
    );

Map<String, dynamic> _$OAuth2TokenResponseToJson(OAuth2TokenResponse instance) {
  final val = <String, dynamic>{
    'access_token': instance.accessToken,
    'token_type': _$OAuth2TokenResponseTokenTypeEnumEnumMap[instance.tokenType]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('expires_in', instance.expiresIn);
  writeNotNull('refresh_token', instance.refreshToken);
  val['user_id'] = instance.userId;
  return val;
}

const _$OAuth2TokenResponseTokenTypeEnumEnumMap = {
  OAuth2TokenResponseTokenTypeEnum.bearer: 'bearer',
};
