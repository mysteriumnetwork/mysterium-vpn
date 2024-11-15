// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_authorization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2AuthorizationRequest _$OAuth2AuthorizationRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2AuthorizationRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'response_type',
            'client_id',
            'code_challenge',
            'code_challenge_method',
            'request_id'
          ],
        );
        final val = OAuth2AuthorizationRequest(
          responseType: $checkedConvert('response_type',
              (v) => $enumDecode(_$OAuth2AuthorizationRequestResponseTypeEnumEnumMap, v)),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$OAuth2AuthorizationRequestClientIdEnumEnumMap, v)),
          codeChallenge: $checkedConvert('code_challenge', (v) => v as String),
          codeChallengeMethod: $checkedConvert('code_challenge_method',
              (v) => $enumDecode(_$OAuth2AuthorizationRequestCodeChallengeMethodEnumEnumMap, v)),
          requestId: $checkedConvert('request_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'responseType': 'response_type',
        'clientId': 'client_id',
        'codeChallenge': 'code_challenge',
        'codeChallengeMethod': 'code_challenge_method',
        'requestId': 'request_id'
      },
    );

Map<String, dynamic> _$OAuth2AuthorizationRequestToJson(OAuth2AuthorizationRequest instance) =>
    <String, dynamic>{
      'response_type': _$OAuth2AuthorizationRequestResponseTypeEnumEnumMap[instance.responseType]!,
      'client_id': _$OAuth2AuthorizationRequestClientIdEnumEnumMap[instance.clientId]!,
      'code_challenge': instance.codeChallenge,
      'code_challenge_method':
          _$OAuth2AuthorizationRequestCodeChallengeMethodEnumEnumMap[instance.codeChallengeMethod]!,
      'request_id': instance.requestId,
    };

const _$OAuth2AuthorizationRequestResponseTypeEnumEnumMap = {
  OAuth2AuthorizationRequestResponseTypeEnum.activationNone: 'activation_none',
};

const _$OAuth2AuthorizationRequestClientIdEnumEnumMap = {
  OAuth2AuthorizationRequestClientIdEnum.web: 'web',
  OAuth2AuthorizationRequestClientIdEnum.app: 'app',
  OAuth2AuthorizationRequestClientIdEnum.extension_: 'extension',
};

const _$OAuth2AuthorizationRequestCodeChallengeMethodEnumEnumMap = {
  OAuth2AuthorizationRequestCodeChallengeMethodEnum.plain: 'plain',
  OAuth2AuthorizationRequestCodeChallengeMethodEnum.s256: 'S256',
  OAuth2AuthorizationRequestCodeChallengeMethodEnum.s2562: 's256',
};
