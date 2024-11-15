// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_link_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MagicLinkRequest _$MagicLinkRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'MagicLinkRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['email', 'client_id', 'code_challenge', 'code_challenge_method'],
        );
        final val = MagicLinkRequest(
          email: $checkedConvert('email', (v) => v as String),
          clientId: $checkedConvert(
              'client_id', (v) => $enumDecode(_$MagicLinkRequestClientIdEnumEnumMap, v)),
          codeChallenge: $checkedConvert('code_challenge', (v) => v as String),
          codeChallengeMethod: $checkedConvert('code_challenge_method',
              (v) => $enumDecode(_$MagicLinkRequestCodeChallengeMethodEnumEnumMap, v)),
          continueTo: $checkedConvert('continue_to', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'clientId': 'client_id',
        'codeChallenge': 'code_challenge',
        'codeChallengeMethod': 'code_challenge_method',
        'continueTo': 'continue_to'
      },
    );

Map<String, dynamic> _$MagicLinkRequestToJson(MagicLinkRequest instance) {
  final val = <String, dynamic>{
    'email': instance.email,
    'client_id': _$MagicLinkRequestClientIdEnumEnumMap[instance.clientId]!,
    'code_challenge': instance.codeChallenge,
    'code_challenge_method':
        _$MagicLinkRequestCodeChallengeMethodEnumEnumMap[instance.codeChallengeMethod]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('continue_to', instance.continueTo);
  return val;
}

const _$MagicLinkRequestClientIdEnumEnumMap = {
  MagicLinkRequestClientIdEnum.web: 'web',
  MagicLinkRequestClientIdEnum.app: 'app',
  MagicLinkRequestClientIdEnum.extension_: 'extension',
};

const _$MagicLinkRequestCodeChallengeMethodEnumEnumMap = {
  MagicLinkRequestCodeChallengeMethodEnum.plain: 'plain',
  MagicLinkRequestCodeChallengeMethodEnum.s256: 'S256',
  MagicLinkRequestCodeChallengeMethodEnum.s2562: 's256',
};
