// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activation_authorization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivationAuthorizationRequest _$ActivationAuthorizationRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ActivationAuthorizationRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['response_type', 'client_id', 'request_id'],
        );
        final val = ActivationAuthorizationRequest(
          responseType: $checkedConvert('response_type',
              (v) => $enumDecode(_$ActivationAuthorizationRequestResponseTypeEnumEnumMap, v)),
          clientId: $checkedConvert('client_id',
              (v) => $enumDecode(_$ActivationAuthorizationRequestClientIdEnumEnumMap, v)),
          requestId: $checkedConvert('request_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'responseType': 'response_type',
        'clientId': 'client_id',
        'requestId': 'request_id'
      },
    );

Map<String, dynamic> _$ActivationAuthorizationRequestToJson(
        ActivationAuthorizationRequest instance) =>
    <String, dynamic>{
      'response_type':
          _$ActivationAuthorizationRequestResponseTypeEnumEnumMap[instance.responseType]!,
      'client_id': _$ActivationAuthorizationRequestClientIdEnumEnumMap[instance.clientId]!,
      'request_id': instance.requestId,
    };

const _$ActivationAuthorizationRequestResponseTypeEnumEnumMap = {
  ActivationAuthorizationRequestResponseTypeEnum.activationNone: 'activation_none',
};

const _$ActivationAuthorizationRequestClientIdEnumEnumMap = {
  ActivationAuthorizationRequestClientIdEnum.web: 'web',
  ActivationAuthorizationRequestClientIdEnum.app: 'app',
  ActivationAuthorizationRequestClientIdEnum.extension_: 'extension',
};
