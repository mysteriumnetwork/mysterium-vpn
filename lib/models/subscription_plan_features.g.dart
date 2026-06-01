// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionPlanFeatures _$SubscriptionPlanFeaturesFromJson(
  Map<String, dynamic> json,
) => _SubscriptionPlanFeatures(
  name: json['name'] as String,
  planIds: (json['planIds'] as List<dynamic>).map((e) => e as String).toSet(),
  previewFeatures: (json['previewFeatures'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  detailedFeatures: json['detailedFeatures'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SubscriptionPlanFeaturesToJson(
  _SubscriptionPlanFeatures instance,
) => <String, dynamic>{
  'name': instance.name,
  'planIds': instance.planIds.toList(),
  'previewFeatures': instance.previewFeatures.toList(),
  'detailedFeatures': instance.detailedFeatures,
};
