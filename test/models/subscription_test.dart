import 'package:flutter_test/flutter_test.dart';
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
}
