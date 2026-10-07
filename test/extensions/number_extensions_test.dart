import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

void main() {
  group('NumberExtensions', () {
    test('pricePerMonth returns correct value with currency symbol', () {
      const amount = 120.0;
      final result = amount.pricePerMonth(months: 12, currencySymbol: r'$', currencyCode: 'USD');
      expect(result, r'$10.00');
    });

    test('pricePerMonth returns correct value with currency code', () {
      const amount = 120.0;
      final result = amount.pricePerMonth(months: 12, currencySymbol: '', currencyCode: 'USD');
      expect(result, 'USD10.00');
    });

    test('price returns correct value with currency symbol', () {
      const amount = 120.0;
      final result = amount.price(currencySymbol: r'$', currencyCode: 'USD');
      expect(result, r'$120.00');
    });

    test('price returns correct value with currency code', () {
      const amount = 120.0;
      final result = amount.price(currencySymbol: '', currencyCode: 'USD');
      expect(result, 'USD120.00');
    });
  });

  group('NullableDoubleExtensions.isNullOrNotFinite', () {
    test('is true for null, NaN, and infinity', () {
      expect(null.isNullOrNotFinite, isTrue);
      expect(double.nan.isNullOrNotFinite, isTrue);
      expect(double.infinity.isNullOrNotFinite, isTrue);
      expect(double.negativeInfinity.isNullOrNotFinite, isTrue);
    });

    test('is false for a normal number', () {
      expect(74.23.isNullOrNotFinite, isFalse);
      expect(0.0.isNullOrNotFinite, isFalse);
    });
  });
}
