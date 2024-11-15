// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCheckResponse _$AuthCheckResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AuthCheckResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['username', 'user_id'],
        );
        final val = AuthCheckResponse(
          username: $checkedConvert('username', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'userId': 'user_id'},
    );

Map<String, dynamic> _$AuthCheckResponseToJson(AuthCheckResponse instance) => <String, dynamic>{
      'username': instance.username,
      'user_id': instance.userId,
    };
