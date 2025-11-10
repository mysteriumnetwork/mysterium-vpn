// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => _Subscription(
      active: json['active'] as bool,
      planId: json['plan_id'] as String?,
      gateway: json['gateway'] as String?,
      activeUntil:
          json['active_until'] == null ? null : DateTime.parse(json['active_until'] as String),
      expired: json['expired'] as bool?,
      recurring: json['recurring'] as bool?,
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) => <String, dynamic>{
      'active': instance.active,
      'plan_id': instance.planId,
      'gateway': instance.gateway,
      'active_until': instance.activeUntil?.toIso8601String(),
      'expired': instance.expired,
      'recurring': instance.recurring,
    };
