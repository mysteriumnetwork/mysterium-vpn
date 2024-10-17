// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanDetailsImpl _$$PlanDetailsImplFromJson(Map<String, dynamic> json) => _$PlanDetailsImpl(
      id: json['id'] as String,
      enabled: Interval.fromJson(json['interval'] as Map<String, dynamic>),
      supportedGateways:
          (json['supported_gateways'] as List<dynamic>).map((e) => e as String).toList(),
      appleProductId: json['apple_product_id'] as String,
      googleProductId: json['google_product_id'] as String,
    );

Map<String, dynamic> _$$PlanDetailsImplToJson(_$PlanDetailsImpl instance) => <String, dynamic>{
      'id': instance.id,
      'interval': instance.enabled,
      'supported_gateways': instance.supportedGateways,
      'apple_product_id': instance.appleProductId,
      'google_product_id': instance.googleProductId,
    };

_$IntervalImpl _$$IntervalImplFromJson(Map<String, dynamic> json) => _$IntervalImpl(
      unit: json['unit'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$IntervalImplToJson(_$IntervalImpl instance) => <String, dynamic>{
      'unit': instance.unit,
      'amount': instance.amount,
    };
