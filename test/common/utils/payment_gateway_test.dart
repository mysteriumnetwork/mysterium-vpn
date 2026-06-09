import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';

void main() {
  group('isMobilePaymentGateway', () {
    test('returns true for apple and google (lowercase)', () {
      expect(isMobilePaymentGateway('apple'), isTrue);
      expect(isMobilePaymentGateway('google'), isTrue);
    });

    test('is case-insensitive (backend may return capitalized gateways)', () {
      expect(isMobilePaymentGateway('Apple'), isTrue);
      expect(isMobilePaymentGateway('GOOGLE'), isTrue);
    });

    test('returns false for web gateways and null', () {
      expect(isMobilePaymentGateway('stripe'), isFalse);
      expect(isMobilePaymentGateway('paypal'), isFalse);
      expect(isMobilePaymentGateway(null), isFalse);
    });
  });

  group('storeNameForGateway', () {
    test('returns Apple App Store for apple gateway', () {
      expect(storeNameForGateway('apple'), 'Apple App Store');
    });

    test('returns Google Play Store for google gateway', () {
      expect(storeNameForGateway('google'), 'Google Play Store');
    });

    test('is case-insensitive', () {
      expect(storeNameForGateway('Apple'), 'Apple App Store');
      expect(storeNameForGateway('GOOGLE'), 'Google Play Store');
    });

    test('returns empty string for non-store gateways', () {
      expect(storeNameForGateway('stripe'), '');
      expect(storeNameForGateway('paypal'), '');
      expect(storeNameForGateway(null), '');
    });
  });
}
