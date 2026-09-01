// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotifierRegistration _$NotifierRegistrationFromJson(Map<String, dynamic> json) =>
    _NotifierRegistration(
      externalUserId: json['externalUserId'] as String,
      token: json['token'] as String,
      platform: $enumDecode(_$NotifierPlatformEnumMap, json['platform']),
      contractVersion: (json['contractVersion'] as num).toInt(),
      pending: json['pending'] as bool? ?? false,
    );

Map<String, dynamic> _$NotifierRegistrationToJson(_NotifierRegistration instance) =>
    <String, dynamic>{
      'externalUserId': instance.externalUserId,
      'token': instance.token,
      'platform': _$NotifierPlatformEnumMap[instance.platform]!,
      'contractVersion': instance.contractVersion,
      'pending': instance.pending,
    };

const _$NotifierPlatformEnumMap = {
  NotifierPlatform.ios: 'ios',
  NotifierPlatform.android: 'android',
  NotifierPlatform.macos: 'macos',
};
