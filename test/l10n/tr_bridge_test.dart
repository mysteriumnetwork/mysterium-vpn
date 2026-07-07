import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';

void main() {
  setUp(() async => S.load(const Locale('en')));

  test('resolves a country-code key', () {
    expect(Tr.byKey('austria'), 'Austria');
  });

  test('resolves a theme-mode key', () {
    expect(Tr.byKey('system'), 'Default');
    expect(Tr.byKey('light'), 'Light');
  });

  test('resolves a ConfigCat-driven feature-description key', () {
    expect(Tr.byKey('subscriptionPlanWireGuardDesc').isNotEmpty, isTrue);
    expect(Tr.byKey('subscriptionPlanWireGuardDesc'), isNot('subscriptionPlanWireGuardDesc'));
  });

  test('unknown key returns the key itself (existence-probe contract)', () {
    expect(Tr.byKey('totally_unknown_key_xyz'), 'totally_unknown_key_xyz');
  });

  test('tracks the active locale', () async {
    await S.load(const Locale('de'));
    expect(Tr.byKey('system'), 'System');
  });
}
