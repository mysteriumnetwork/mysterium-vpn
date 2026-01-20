// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_cat_user_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConfigCatUserCustom _$ConfigCatUserCustomFromJson(Map<String, dynamic> json) =>
    _ConfigCatUserCustom(
      platform: json['platform'] as String,
      version: json['version'] as String,
      city: json['city'] as String?,
      subscriptionSource: json['subscriptionSource'] as String?,
      subscriptionPlan: json['subscriptionPlan'] as String?,
      expirationDate: json['expirationDate'] as String?,
      subscriptionDuration: json['subscriptionDuration'] as String?,
      recurring: json['recurring'] as String?,
    );

Map<String, dynamic> _$ConfigCatUserCustomToJson(_ConfigCatUserCustom instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'version': instance.version,
      'city': instance.city,
      'subscriptionSource': instance.subscriptionSource,
      'subscriptionPlan': instance.subscriptionPlan,
      'expirationDate': instance.expirationDate,
      'subscriptionDuration': instance.subscriptionDuration,
      'recurring': instance.recurring,
    };
