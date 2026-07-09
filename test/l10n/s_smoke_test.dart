import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

void main() {
  test('S.current resolves a known key after load', () async {
    await S.load(const Locale('en'));
    expect(S.current.account, 'Account');
  });

  test('country-coded locale resolves to language-only ARB', () async {
    // A device may report a country-coded locale (en_US, de_DE); S matches on languageCode.
    await S.load(const Locale('en', 'US'));
    expect(S.current.account, 'Account');
    await S.load(const Locale('de', 'DE'));
    expect(S.current.account, 'Konto');
  });

  test('named placeholder + ICU plural methods render', () async {
    await S.load(const Locale('en'));
    expect(S.current.locationUnavailableTitle('Austria'), 'Austria is not available');
    expect(S.current.locationItemCityCount(1), '1 City');
    expect(S.current.locationItemCityCount(3), '3 Cities');
  });
}
