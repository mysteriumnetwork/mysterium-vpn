import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/subscription_plan_resolver.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:vpn_api/vpn_api.dart';

SubscriptionConfigResponsePlansInner _plan({
  required String id,
  required List<String> supportedGateways,
  String intervalUnit = 'month',
  int intervalAmount = 1,
}) => SubscriptionConfigResponsePlansInner(
  id: id,
  interval: SubscriptionConfigResponsePlansInnerInterval(
    unit: SubscriptionConfigResponsePlansInnerIntervalUnitEnum.values.firstWhere(
      (u) => u.value == intervalUnit,
    ),
    amount: intervalAmount,
  ),
  price: SubscriptionConfigResponsePlansInnerPrice(USD: 0),
  prices: const [],
  supportedGateways: supportedGateways,
  metadata: SubscriptionConfigResponsePlansInnerMetadata(),
);

SubscriptionConfigResponse _config(List<SubscriptionConfigResponsePlansInner> plans) =>
    SubscriptionConfigResponse(
      gateways: const [],
      plans: plans,
      countries: const [],
      stripePublishableKey: '',
      stripeReturnUrl: '',
    );

SubscriptionPlanFeatures _tier(String name, Set<String> planIds) => SubscriptionPlanFeatures(
  name: name,
  planIds: planIds,
  previewFeatures: const {},
  detailedFeatures: const {},
);

void main() {
  // Tier order matches the production order: Basic, Plus, Pro
  // (later index = higher tier).
  final planFeatures = [
    _tier('Basic', {'plan_monthly_basic', 'plan_yearly_basic'}),
    _tier('Plus', {'plan_monthly_plus', 'plan_yearly_plus'}),
    _tier('Pro', {'plan_monthly_pro', 'plan_yearly_pro', 'plan_2_years_pro'}),
  ];

  group('maxPlanIdForGateway', () {
    test('returns null when no plan supports the gateway', () {
      final config = _config([
        _plan(id: 'plan_yearly_plus', supportedGateways: ['stripe'], intervalUnit: 'year'),
      ]);
      expect(maxPlanIdForGateway('paypal', config, planFeatures), isNull);
    });

    test('picks the only available plan when one is supported', () {
      final config = _config([
        _plan(id: 'plan_monthly_basic', supportedGateways: ['google']),
      ]);
      expect(maxPlanIdForGateway('google', config, planFeatures), 'plan_monthly_basic');
    });

    test('picks higher tier over longer duration', () {
      // Pro 1-month beats Plus 1-year on tier.
      final config = _config([
        _plan(id: 'plan_monthly_pro', supportedGateways: ['stripe']),
        _plan(id: 'plan_yearly_plus', supportedGateways: ['stripe'], intervalUnit: 'year'),
      ]);
      expect(maxPlanIdForGateway('stripe', config, planFeatures), 'plan_monthly_pro');
    });

    test('picks longer duration within the same tier', () {
      // Pro 2-year beats Pro 1-year, beats Pro monthly.
      final config = _config([
        _plan(id: 'plan_monthly_pro', supportedGateways: ['stripe']),
        _plan(id: 'plan_yearly_pro', supportedGateways: ['stripe'], intervalUnit: 'year'),
        _plan(
          id: 'plan_2_years_pro',
          supportedGateways: ['stripe'],
          intervalUnit: 'year',
          intervalAmount: 2,
        ),
      ]);
      expect(maxPlanIdForGateway('stripe', config, planFeatures), 'plan_2_years_pro');
    });

    test('filters plans by supportedGateways before ranking', () {
      // Pro plans exist for stripe but not for google — google's max
      // should be plan_yearly_plus.
      final config = _config([
        _plan(id: 'plan_monthly_plus', supportedGateways: ['google']),
        _plan(id: 'plan_yearly_plus', supportedGateways: ['google'], intervalUnit: 'year'),
        _plan(
          id: 'plan_2_years_pro',
          supportedGateways: ['stripe'],
          intervalUnit: 'year',
          intervalAmount: 2,
        ),
      ]);
      expect(maxPlanIdForGateway('google', config, planFeatures), 'plan_yearly_plus');
      expect(maxPlanIdForGateway('stripe', config, planFeatures), 'plan_2_years_pro');
    });

    test('treats plans missing from planFeatures as the lowest tier', () {
      // An unknown plan id has tierIndex = -1; a known Basic plan beats it.
      final config = _config([
        _plan(id: 'plan_unknown', supportedGateways: ['stripe'], intervalUnit: 'year'),
        _plan(id: 'plan_monthly_basic', supportedGateways: ['stripe']),
      ]);
      expect(maxPlanIdForGateway('stripe', config, planFeatures), 'plan_monthly_basic');
    });

    test('ranks Pro above Plus even when planFeatures omits the Pro tier', () {
      // Production planFeatures only lists the in-app sellable tiers (Basic,
      // Plus) — Pro is web-only and absent. The intrinsic tier order must
      // still rank a 2-year Pro plan above a same-duration Plus plan.
      final featuresWithoutPro = [
        _tier('Basic', {'plan_monthly_basic', 'plan_yearly_basic'}),
        _tier('Plus', {'plan_monthly_plus', 'plan_yearly_plus'}),
      ];
      final config = _config([
        _plan(
          id: 'plan_2_years_plus',
          supportedGateways: ['stripe'],
          intervalUnit: 'year',
          intervalAmount: 2,
        ),
        _plan(
          id: 'plan_2_years_pro',
          supportedGateways: ['stripe'],
          intervalUnit: 'year',
          intervalAmount: 2,
        ),
      ]);
      expect(maxPlanIdForGateway('stripe', config, featuresWithoutPro), 'plan_2_years_pro');
    });

    test('ranks a duration variant not enumerated in planFeatures by its tier token', () {
      // Production planFeatures often lists only monthly/yearly ids per tier
      // and omits the 2-year variant. The 2-year Pro plan must still be ranked
      // as Pro (by its "_pro" token), so it wins over 1-year Pro.
      final featuresWithoutTwoYear = [
        _tier('Basic', {'plan_monthly_basic', 'plan_yearly_basic'}),
        _tier('Plus', {'plan_monthly_plus', 'plan_yearly_plus'}),
        _tier('Pro', {'plan_monthly_pro', 'plan_yearly_pro'}),
      ];
      final config = _config([
        _plan(id: 'plan_yearly_pro', supportedGateways: ['stripe'], intervalUnit: 'year'),
        _plan(
          id: 'plan_2_years_pro',
          supportedGateways: ['stripe'],
          intervalUnit: 'year',
          intervalAmount: 2,
        ),
      ]);
      expect(maxPlanIdForGateway('stripe', config, featuresWithoutTwoYear), 'plan_2_years_pro');
    });
  });
}
