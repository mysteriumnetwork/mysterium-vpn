import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/tr_bridge_generator.dart';

/// Fails when `tr_bridge_keys.g.dart` is out of sync with `intl_en.arb` — e.g.
/// someone edited the ARB but didn't regenerate. Compares the checked-in file's
/// keys against what `renderTrBridge` (the shared generator) would produce, so
/// the filter rule can't drift between generator and guard.
void main() {
  test('tr_bridge_keys.g.dart is in sync with intl_en.arb', () {
    final arb = jsonDecode(File('lib/l10n/intl_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final keyRe = RegExp(r"'([A-Za-z0-9_]+)': \(s\)");
    List<String> keysOf(String source) => keyRe.allMatches(source).map((m) => m.group(1)!).toList();

    final expected = keysOf(renderTrBridge(arb));
    final actual = keysOf(File('lib/l10n/tr_bridge_keys.g.dart').readAsStringSync());

    expect(
      actual,
      expected,
      reason: 'tr_bridge_keys.g.dart is stale — run `make localizely-generate`',
    );
  });
}
