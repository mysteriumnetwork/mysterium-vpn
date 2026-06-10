import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart';

/// Intrinsic tier order encoded in plan ids (`*_basic` < `*_plus` < `*_pro`).
/// This is the authoritative product hierarchy. It backstops the plan-features
/// list, which only enumerates the in-app *sellable* tiers and deliberately
/// omits the web-only Pro plans — so it can't be relied on to rank Pro.
const Map<String, int> _intrinsicTierRankByToken = {'basic': 0, 'plus': 1, 'pro': 2};

/// Picks the highest tier + longest duration plan available for [gateway]
/// from the subscription config. Tier is resolved from [planFeatures] where
/// listed, then by the plan id's tier token, and finally by the intrinsic
/// Basic/Plus/Pro order. Duration is read from each plan's interval. Returns
/// `null` if no plan supports the given gateway.
String? maxPlanIdForGateway(
  String gateway,
  SubscriptionConfigResponse config,
  List<SubscriptionPlanFeatures> planFeatures,
) {
  // Tier token = the trailing segment of a plan id (e.g. "pro" in
  // "plan_2_years_pro", "basic" in "plan_yearly_basic"). Legacy ids without a
  // tier suffix (e.g. "plan_monthly") yield a non-tier token that matches
  // nothing, leaving them unranked.
  String tierToken(String planId) {
    final i = planId.lastIndexOf('_');
    return i == -1 ? planId : planId.substring(i + 1);
  }

  int tierIndex(String planId) {
    for (var i = planFeatures.length - 1; i >= 0; i--) {
      if (planFeatures[i].planIds.contains(planId)) {
        return i;
      }
    }
    // Fall back to the tier token so duration variants not enumerated in
    // planFeatures (notably 2-year plans) still rank with their tier instead
    // of dropping to the bottom.
    final token = tierToken(planId);
    for (var i = planFeatures.length - 1; i >= 0; i--) {
      if (planFeatures[i].planIds.any((id) => tierToken(id) == token)) {
        return i;
      }
    }
    // Tier absent from planFeatures entirely (e.g. web-only Pro): use the
    // intrinsic product order so it still outranks lower tiers.
    return _intrinsicTierRankByToken[token] ?? -1;
  }

  int durationMonths(SubscriptionConfigResponsePlansInner plan) {
    final amount = plan.interval.amount.toInt();
    return plan.interval.unit == SubscriptionConfigResponsePlansInnerIntervalUnitEnum.year
        ? amount * 12
        : amount;
  }

  // Resolve tier and duration once per eligible plan, then sort — keeps the
  // (potentially two-pass) tierIndex lookup out of the O(n log n) comparator.
  final ranked = config.plans
      .where((p) => p.supportedGateways.contains(gateway))
      .map((p) => (id: p.id, tier: tierIndex(p.id), months: durationMonths(p)))
      .toList();
  if (ranked.isEmpty) {
    return null;
  }

  ranked.sort((a, b) {
    final byTier = b.tier.compareTo(a.tier);
    return byTier != 0 ? byTier : b.months.compareTo(a.months);
  });

  return ranked.first.id;
}
