// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) =>
    _PushNotification(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      launchUrl: json['launchUrl'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      rawPayload: json['rawPayload'] as Map<String, dynamic>?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$PushNotificationToJson(_PushNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'launchUrl': instance.launchUrl,
      'additionalData': instance.additionalData,
      'rawPayload': instance.rawPayload,
      'category': instance.category,
    };
