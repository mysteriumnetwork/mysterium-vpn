// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionRequestImpl _$$SubscriptionRequestImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionRequestImpl(
      gatewayId: json['gateway_id'] as String,
      planId: json['plan_id'] as String,
    );

Map<String, dynamic> _$$SubscriptionRequestImplToJson(_$SubscriptionRequestImpl instance) =>
    <String, dynamic>{
      'gateway_id': instance.gatewayId,
      'plan_id': instance.planId,
    };
