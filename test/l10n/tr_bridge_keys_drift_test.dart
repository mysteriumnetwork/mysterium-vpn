import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Fails when `tr_bridge_keys.g.dart` is out of sync with `intl_en.arb` — e.g.
/// someone edited the ARB but didn't regenerate. The builder derives the bridge
/// from the same rule (no-`@`, no-`{...}` keys), so this guards against a stale
/// checked-in file regardless of how generation was (not) run.
void main() {
  test('tr_bridge_keys.g.dart is in sync with intl_en.arb', () {
    final arb = jsonDecode(File('lib/l10n/intl_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final expected =
        arb.keys
            .where((k) => !k.startsWith('@'))
            .where((k) => !arb[k].toString().contains('{'))
            .toList()
          ..sort();

    final generated = File('lib/l10n/tr_bridge_keys.g.dart').readAsStringSync();
    final actual = RegExp(
      r"'([A-Za-z0-9_]+)': \(s\)",
    ).allMatches(generated).map((m) => m.group(1)!).toList();

    expect(
      actual,
      expected,
      reason: 'tr_bridge_keys.g.dart is stale — run `make localizely-generate`',
    );
  });
}
