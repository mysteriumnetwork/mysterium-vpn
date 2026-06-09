import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';

void main() {
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
