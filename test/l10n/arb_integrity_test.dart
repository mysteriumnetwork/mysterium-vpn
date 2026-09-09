import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the ARB files against the two ways `make localizely-fetch` corrupts
/// them. `tool/normalize_arb.dart` repairs both; this fails the build if a
/// fetch is ever run without it.
void main() {
  final arbs =
      Directory(
          'lib/l10n',
        ).listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final emptyArm = RegExp(r'\b(zero|one|two|few|many|other)\{\}');

  test('every locale file is present', () {
    expect(arbs, isNotEmpty);
    expect(arbs.any((f) => f.path.endsWith('intl_en.arb')), isTrue);
  });

  group('no fetch corruption', () {
    for (final file in arbs) {
      final name = file.uri.pathSegments.last;
      final json = Map<String, dynamic>.from(jsonDecode(file.readAsStringSync()) as Map);

      test('$name has no emptied plural arms', () {
        final broken = json.entries
            .where((e) => e.value is String && emptyArm.hasMatch(e.value as String))
            .map((e) => e.key)
            .toList();
        expect(
          broken,
          isEmpty,
          reason:
              'Emptied plural arm(s) in $name: $broken. Localizely drops '
              'non-CLDR arms; run `make localizely-fetch` (which normalizes) '
              'rather than intl_utils:localizely_download directly.',
        );
      });

      // Asserted on the raw source, not the decoded map: jsonDecode turns
      // \uD83C\uDDE9 back into the flag, so a decoded check can never see the
      // escaping the fetch introduces.
      test('$name keeps non-BMP characters literal', () {
        final raw = file.readAsStringSync();
        final escapes = RegExp(r'\\u[dD][89abAB][0-9a-fA-F]{2}').allMatches(raw);
        expect(
          escapes.map((m) => m.group(0)).toSet(),
          isEmpty,
          reason:
              'Surrogate-pair escapes in $name. The Localizely download '
              're-escapes emoji; run `make localizely-fetch` (which '
              'normalizes) rather than intl_utils:localizely_download.',
        );
      });

      test('$name has no empty translations', () {
        final blank = json.entries
            .where((e) => !e.key.startsWith('@'))
            .where((e) => e.value is String && (e.value as String).trim().isEmpty)
            .map((e) => e.key)
            .toList();
        expect(blank, isEmpty, reason: 'Empty string(s) in $name: $blank');
      });
    }
  });
}
