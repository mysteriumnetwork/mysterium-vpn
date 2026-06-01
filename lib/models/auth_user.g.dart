// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthData _$AuthDataFromJson(Map<String, dynamic> json) =>
    _AuthData(userId: json['sub'] as String, username: json['username'] as String);

Map<String, dynamic> _$AuthDataToJson(_AuthData instance) => <String, dynamic>{
  'sub': instance.userId,
  'username': instance.username,
};
