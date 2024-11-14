// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthDataImpl _$$AuthDataImplFromJson(Map<String, dynamic> json) => _$AuthDataImpl(
      username: json['username'] as String,
      userId: json['sub'] as String,
    );

Map<String, dynamic> _$$AuthDataImplToJson(_$AuthDataImpl instance) => <String, dynamic>{
      'username': instance.username,
      'sub': instance.userId,
    };
