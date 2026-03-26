// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) => _TokenResponse(
  userId: json['user_id'] as String,
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String?,
);

Map<String, dynamic> _$TokenResponseToJson(_TokenResponse instance) => <String, dynamic>{
  'user_id': instance.userId,
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
};
