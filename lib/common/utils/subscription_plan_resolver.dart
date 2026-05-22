import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart';

/// Picks the highest tier + longest duration plan available for [gateway]
/// from the subscription config. Tier ordering comes from [planFeatures]
/// (the remote-config-driven list where later entries are higher tiers).
/// Duration is read from each plan's interval. Returns `null` if no plan
/// supports the given gateway.
String? maxPlanIdForGateway(
  String gateway,
  SubscriptionConfigResponse config,
  List<SubscriptionPlanFeatures> planFeatures,
) {
  int tierIndex(String planId) {
    for (var i = planFeatures.length - 1; i >= 0; i--) {
      if (planFeatures[i].planIds.contains(planId)) {
        return i;
      }
    }
    return -1;
  }

  int durationMonths(SubscriptionConfigResponsePlansInner plan) {
    final amount = plan.interval.amount.toInt();
    return plan.interval.unit == SubscriptionConfigResponsePlansInnerIntervalUnitEnum.year
        ? amount * 12
        : amount;
  }

  final eligible = config.plans.where((p) => p.supportedGateways.contains(gateway)).toList();
  if (eligible.isEmpty) {
    return null;
  }

  eligible.sort((a, b) {
    final byTier = tierIndex(b.id).compareTo(tierIndex(a.id));
    if (byTier != 0) {
      return byTier;
    }
    return durationMonths(b).compareTo(durationMonths(a));
  });

  return eligible.first.id;
}
