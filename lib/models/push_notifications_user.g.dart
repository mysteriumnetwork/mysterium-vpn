// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushNotificationsUser _$PushNotificationsUserFromJson(Map<String, dynamic> json) =>
    _PushNotificationsUser(
      pushNotificationsId: json['pushNotificationsId'] as String?,
      userId: json['userId'] as String?,
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$PushNotificationsUserToJson(_PushNotificationsUser instance) =>
    <String, dynamic>{
      'pushNotificationsId': instance.pushNotificationsId,
      'userId': instance.userId,
      'tags': instance.tags,
    };
