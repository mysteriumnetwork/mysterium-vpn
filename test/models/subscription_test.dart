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

  Subscription sub(OrderSummary? orderSummary) =>
      Subscription(active: true, orderSummary: orderSummary);

  group('Subscription', () {
    group('hasDiscount', () {
      test('is true for a USD discount', () {
        expect(sub(summary()).hasDiscount, isTrue);
      });

      test('is false when there is no currency symbol', () {
        expect(sub(summary(currency: 'EUR')).hasDiscount, isFalse);
        expect(sub(summary(currency: '  ')).hasDiscount, isFalse);
      });

      test('is false when the amounts match after rounding to cents', () {
        expect(
          sub(
            summary(totalPrice: '9.990000000000001', totalPriceBeforeDiscount: '9.99'),
          ).hasDiscount,
          isFalse,
        );
        expect(
          sub(summary(totalPrice: '10', totalPriceBeforeDiscount: '10.00')).hasDiscount,
          isFalse,
        );
      });

      test('is false when the charged total is not lower', () {
        expect(sub(summary(totalPrice: '90.00')).hasDiscount, isFalse);
      });

      test('is false when an amount is not a finite number', () {
        expect(sub(summary(totalPriceBeforeDiscount: 'n/a')).hasDiscount, isFalse);
        expect(sub(summary(totalPrice: 'NaN')).hasDiscount, isFalse);
        expect(sub(summary(totalPriceBeforeDiscount: 'Infinity')).hasDiscount, isFalse);
      });

      test('is false when there is no order summary', () {
        expect(sub(null).hasDiscount, isFalse);
      });
    });

    group('priceInfo', () {
      test('shows the backend strings with the currency symbol', () {
        final info = sub(
          summary(totalPrice: '74.2300', totalPriceBeforeDiscount: '89.5400'),
        ).priceInfo;

        expect(info?.discountedPrice, r'$74.2300');
        expect(info?.priceBeforeDiscount, r'$89.5400');
      });

      test('is null when the discount should not be shown', () {
        expect(sub(summary(currency: 'EUR')).priceInfo, isNull);
        expect(sub(null).priceInfo, isNull);
      });
    });
  });
}
