// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthDataImpl _$$AuthDataImplFromJson(Map<String, dynamic> json) => _$AuthDataImpl(
      accessToken: json['access_token'] as String,
      username: json['username'] as String,
      userId: json['sub'] as String,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$$AuthDataImplToJson(_$AuthDataImpl instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'username': instance.username,
      'sub': instance.userId,
      'refresh_token': instance.refreshToken,
    };
