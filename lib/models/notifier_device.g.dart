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
      state:
          $enumDecodeNullable(_$NotifierSyncStateEnumMap, json['state']) ??
          NotifierSyncState.settled,
    );

Map<String, dynamic> _$NotifierRegistrationToJson(_NotifierRegistration instance) =>
    <String, dynamic>{
      'externalUserId': instance.externalUserId,
      'token': instance.token,
      'platform': _$NotifierPlatformEnumMap[instance.platform]!,
      'contractVersion': instance.contractVersion,
      'state': _$NotifierSyncStateEnumMap[instance.state]!,
    };

const _$NotifierPlatformEnumMap = {
  NotifierPlatform.ios: 'ios',
  NotifierPlatform.android: 'android',
  NotifierPlatform.macos: 'macos',
};

const _$NotifierSyncStateEnumMap = {
  NotifierSyncState.settled: 'settled',
  NotifierSyncState.pendingRegister: 'pendingRegister',
  NotifierSyncState.pendingDelete: 'pendingDelete',
};
