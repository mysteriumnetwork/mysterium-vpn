import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/ip_refresh_exhausted_message.dart';

void main() {
  test('country location selects the country message key', () {
    expect(ipRefreshExhaustedMessageKey(isCountry: true), 'ipRefreshExhaustedCountry');
  });

  test('city location selects the city message key', () {
    expect(ipRefreshExhaustedMessageKey(isCountry: false), 'ipRefreshExhaustedCity');
  });
}
