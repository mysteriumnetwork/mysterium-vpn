// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthDataImpl _$$AuthDataImplFromJson(Map<String, dynamic> json) => _$AuthDataImpl(
      userId: json['sub'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$$AuthDataImplToJson(_$AuthDataImpl instance) => <String, dynamic>{
      'sub': instance.userId,
      'username': instance.username,
    };
