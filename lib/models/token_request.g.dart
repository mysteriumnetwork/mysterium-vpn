// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenRequest _$TokenRequestFromJson(Map<String, dynamic> json) => _TokenRequest(
  grantType: $enumDecode(_$GrantTypeEnumMap, json['grant_type']),
  deviceId: json['device_id'] as String,
  clientId: json['client_id'] as String? ?? 'app',
  refreshToken: json['refresh_token'] as String?,
  codeVerifier: json['code_verifier'] as String?,
  code: json['code'] as String?,
  googleIdToken: json['google_id_token'] as String?,
  idToken: json['id_token'] as String?,
  authorization: json['authorization'] as String?,
);

Map<String, dynamic> _$TokenRequestToJson(_TokenRequest instance) => <String, dynamic>{
  'grant_type': grantTypeToJson(instance.grantType),
  'device_id': instance.deviceId,
  'client_id': instance.clientId,
  'refresh_token': instance.refreshToken,
  'code_verifier': instance.codeVerifier,
  'code': instance.code,
  'google_id_token': instance.googleIdToken,
  'authorization': authorizationToJson(instance.authorization),
};

const _$GrantTypeEnumMap = {
  GrantType.refreshToken: 'refreshToken',
  GrantType.email: 'email',
  GrantType.apple: 'apple',
  GrantType.google: 'google',
};
