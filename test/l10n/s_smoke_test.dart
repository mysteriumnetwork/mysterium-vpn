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
    expect(S.current.locationItemNodeCount(1), '1 IP');
    expect(S.current.locationItemNodeCount(5), '5 IPs');
    expect(S.current.locationItemStatesCount(1), '1 State');
    expect(S.current.locationItemStatesCount(2), '2 States');
    expect(S.current.locationItemNodeCount(0), '0 IPs');
  });

  test('explicit zero case is honoured', () async {
    await S.load(const Locale('en'));
    expect(S.current.sendAgain(0), 'Send again');
    expect(S.current.sendAgain(1), 'Send again');
    expect(S.current.sendAgain(5), 'Send again (5)');
  });

  // Localizely's export injects a `zero{}` arm, and Intl.pluralLogic prefers an
  // explicit zero over CLDR's `other`. An empty arm would render nothing, and
  // locationItemNodeCount is called with `nodeCount ?? 0`. English is asserted
  // exactly above; these are the locales whose zero arm had to be synthesised.
  test('translated plurals render at zero rather than collapsing to empty', () async {
    for (final locale in ['de', 'ja']) {
      await S.load(Locale(locale));
      expect(S.current.locationItemCityCount(0), isNotEmpty, reason: locale);
      expect(S.current.locationItemNodeCount(0), isNotEmpty, reason: locale);
      expect(S.current.locationItemStatesCount(0), isNotEmpty, reason: locale);
      expect(S.current.sendAgain(0), isNotEmpty, reason: locale);
    }
  });
}
