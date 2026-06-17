import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/ip_refresh_exhausted_message.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

void main() {
  test('country location selects the country message key', () {
    expect(ipRefreshExhaustedMessageKey(isCountry: true), LocaleKeys.ipRefreshExhaustedCountry);
  });

  test('city location selects the city message key', () {
    expect(ipRefreshExhaustedMessageKey(isCountry: false), LocaleKeys.ipRefreshExhaustedCity);
  });
}
