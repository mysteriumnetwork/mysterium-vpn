import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_plan_features.freezed.dart';

part 'subscription_plan_features.g.dart';

@freezed
abstract class SubscriptionPlanFeatures with _$SubscriptionPlanFeatures {
  factory SubscriptionPlanFeatures({
    required String name,
    required Set<String> planIds,
    required Set<String> previewFeatures,
    required Map<String, dynamic> detailedFeatures,
  }) = _SubscriptionPlanFeatures;

  const SubscriptionPlanFeatures._();

  factory SubscriptionPlanFeatures.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFeaturesFromJson(json);
}
