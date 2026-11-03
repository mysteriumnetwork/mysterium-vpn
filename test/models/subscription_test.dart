import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  OrderSummary summary({
    String currency = 'USD',
    String totalPrice = '74.23',
    String totalPriceBeforeDiscount = '89.54',
  }) => OrderSummary(
    currency: currency,
    totalPrice: totalPrice,
    totalPriceBeforeDiscount: totalPriceBeforeDiscount,
  );

  group('OrderSummary', () {
    group('hasDiscount', () {
      test('is true for a USD discount', () {
        expect(summary().hasDiscount, isTrue);
      });

      test('is false when there is no currency symbol', () {
        expect(summary(currency: 'EUR').hasDiscount, isFalse);
        expect(summary(currency: '  ').hasDiscount, isFalse);
      });

      test('is false when the amounts match after rounding to cents', () {
        expect(
          summary(totalPrice: '9.990000000000001', totalPriceBeforeDiscount: '9.99').hasDiscount,
          isFalse,
        );
        expect(summary(totalPrice: '10', totalPriceBeforeDiscount: '10.00').hasDiscount, isFalse);
      });

      test('is false when the charged total is not lower', () {
        expect(summary(totalPrice: '90.00').hasDiscount, isFalse);
      });

      test('is false when an amount is not a finite number', () {
        expect(summary(totalPriceBeforeDiscount: 'n/a').hasDiscount, isFalse);
        expect(summary(totalPrice: 'NaN').hasDiscount, isFalse);
        expect(summary(totalPriceBeforeDiscount: 'Infinity').hasDiscount, isFalse);
      });
    });
  });

  group('Subscription.bonusDuration', () {
    test('is null without an extra duration', () {
      expect(Subscription(active: true).bonusDuration, isNull);
    });

    test('returns the bonus for a positive amount', () {
      final extra = ExtraDuration(amount: 3, unit: ExtraDurationUnit.month);
      expect(Subscription(active: true, extraDuration: extra).bonusDuration, extra);
    });

    test('is null for a zero amount', () {
      final subscription = Subscription(
        active: true,
        extraDuration: ExtraDuration(amount: 0, unit: ExtraDurationUnit.month),
      );
      expect(subscription.bonusDuration, isNull);
    });
  });

  group('Subscription.standardPeriodMonths', () {
    test('reads the period from the plan id', () {
      expect(Subscription(active: true, planId: 'plan_monthly').standardPeriodMonths, 1);
      expect(Subscription(active: true, planId: 'plan_yearly_pro').standardPeriodMonths, 12);
      expect(Subscription(active: true, planId: 'plan_2_years_pro').standardPeriodMonths, 24);
      expect(Subscription(active: true, planId: 'plan_6_months').standardPeriodMonths, 6);
    });

    test('is null for an unrecognised plan id', () {
      expect(Subscription(active: true, planId: 'plan_mystery').standardPeriodMonths, isNull);
      expect(Subscription(active: true).standardPeriodMonths, isNull);
    });

    // The interval is shown to the user as a renewal claim.
    test('does not mistake a longer period for a shorter one', () {
      expect(Subscription(active: true, planId: 'plan_16_months').standardPeriodMonths, 16);
      expect(Subscription(active: true, planId: 'plan_12_years').standardPeriodMonths, 144);
      expect(Subscription(active: true, planId: 'plan_3_years').standardPeriodMonths, 36);
    });
  });
}
