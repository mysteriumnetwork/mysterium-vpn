// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionConfigImpl _$$SubscriptionConfigImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionConfigImpl(
      gateways: (json['gateways'] as List<dynamic>)
          .map((e) => Gateway.fromJson(e as Map<String, dynamic>))
          .toList(),
      plans: (json['plans'] as List<dynamic>)
          .map((e) => PlanDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SubscriptionConfigImplToJson(_$SubscriptionConfigImpl instance) =>
    <String, dynamic>{
      'gateways': instance.gateways,
      'plans': instance.plans,
    };
