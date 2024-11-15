// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_authorization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeAuthorizationRequest _$CodeAuthorizationRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CodeAuthorizationRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'response_type',
            'client_id',
            'code_challenge',
            'code_challenge_method'
          ],
        );
        final val = CodeAuthorizationRequest(
          responseType: $checkedConvert('response_type',
              (v) => $enumDecode(_$CodeAuthorizationRequestResponseTypeEnumEnumMap, v)),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$CodeAuthorizationRequestClientIdEnumEnumMap, v)),
          codeChallenge: $checkedConvert('code_challenge', (v) => v as String),
          codeChallengeMethod: $checkedConvert('code_challenge_method',
              (v) => $enumDecode(_$CodeAuthorizationRequestCodeChallengeMethodEnumEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {
        'responseType': 'response_type',
        'clientId': 'client_id',
        'codeChallenge': 'code_challenge',
        'codeChallengeMethod': 'code_challenge_method'
      },
    );

Map<String, dynamic> _$CodeAuthorizationRequestToJson(CodeAuthorizationRequest instance) =>
    <String, dynamic>{
      'response_type': _$CodeAuthorizationRequestResponseTypeEnumEnumMap[instance.responseType]!,
      'client_id': _$CodeAuthorizationRequestClientIdEnumEnumMap[instance.clientId]!,
      'code_challenge': instance.codeChallenge,
      'code_challenge_method':
          _$CodeAuthorizationRequestCodeChallengeMethodEnumEnumMap[instance.codeChallengeMethod]!,
    };

const _$CodeAuthorizationRequestResponseTypeEnumEnumMap = {
  CodeAuthorizationRequestResponseTypeEnum.code: 'code',
};

const _$CodeAuthorizationRequestClientIdEnumEnumMap = {
  CodeAuthorizationRequestClientIdEnum.web: 'web',
  CodeAuthorizationRequestClientIdEnum.app: 'app',
  CodeAuthorizationRequestClientIdEnum.extension_: 'extension',
};

const _$CodeAuthorizationRequestCodeChallengeMethodEnumEnumMap = {
  CodeAuthorizationRequestCodeChallengeMethodEnum.plain: 'plain',
  CodeAuthorizationRequestCodeChallengeMethodEnum.s256: 'S256',
  CodeAuthorizationRequestCodeChallengeMethodEnum.s2562: 's256',
};
