// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppPopup _$InAppPopupFromJson(Map<String, dynamic> json) => InAppPopup(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String?,
      imageUrl: json['imageUrl'] as String?,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => InAppMessageAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InAppPopupToJson(InAppPopup instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'imageUrl': instance.imageUrl,
      'actions': instance.actions,
      'type': instance.$type,
    };

InAppBanner _$InAppBannerFromJson(Map<String, dynamic> json) => InAppBanner(
      id: json['id'] as String,
      title: json['title'] as String,
      iconUrl: json['iconUrl'] as String?,
      action: json['action'] == null
          ? null
          : InAppMessageAction.fromJson(json['action'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InAppBannerToJson(InAppBanner instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconUrl': instance.iconUrl,
      'action': instance.action,
      'type': instance.$type,
    };

AppLaunch _$AppLaunchFromJson(Map<String, dynamic> json) => AppLaunch(
      repeatInterval: Duration(microseconds: (json['repeatInterval'] as num).toInt()),
    );

Map<String, dynamic> _$AppLaunchToJson(AppLaunch instance) => <String, dynamic>{
      'repeatInterval': instance.repeatInterval.inMicroseconds,
    };

InAppActionPrimary _$InAppActionPrimaryFromJson(Map<String, dynamic> json) => InAppActionPrimary(
      label: json['label'] as String,
      url: json['url'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InAppActionPrimaryToJson(InAppActionPrimary instance) => <String, dynamic>{
      'label': instance.label,
      'url': instance.url,
      'type': instance.$type,
    };

InAppActionSecondary _$InAppActionSecondaryFromJson(Map<String, dynamic> json) =>
    InAppActionSecondary(
      label: json['label'] as String,
      url: json['url'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InAppActionSecondaryToJson(InAppActionSecondary instance) =>
    <String, dynamic>{
      'label': instance.label,
      'url': instance.url,
      'type': instance.$type,
    };
