import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the two ways a plural key silently stops working in this project.
/// Both are Localizely export artefacts, and neither throws — they just render
/// wrong text, so only an ARB-level scan catches them across all 14 locales.
void main() {
  final arbs = _loadArbs();

  // Localizely serialises a damaged plural key as `{one=…, other=…}`. intl_utils
  // then emits Intl.message with that literal instead of Intl.plural, so the raw
  // braces reach the UI. See docs/localizely-plural-repair.md.
  test('no ARB uses Localizely pseudo-plural syntax', () {
    final pseudoPlural = RegExp(r'^\{\s*(zero|one|two|few|many|other)\s*=');
    final offenders = <String>[];

    arbs.forEach((locale, entries) {
      entries.forEach((key, value) {
        if (pseudoPlural.hasMatch(value)) {
          offenders.add('$locale: $key = $value');
        }
      });
    });

    expect(
      offenders,
      isEmpty,
      reason:
          'Rewrite as ICU: {count, plural, one{…} other{…}}. Do not repair these '
          'by re-uploading to Localizely — see docs/localizely-plural-repair.md.\n'
          '${offenders.join('\n')}',
    );
  });

  // Localizely injects `zero{}` for languages with no CLDR zero category, and
  // Intl.pluralLogic prefers an explicit zero at howMany == 0 before consulting
  // CLDR — so an empty arm renders ''. A key reached with 0 goes blank.
  test('plural keys reachable with 0 have a non-empty zero arm', () {
    final usedKeys = _keysReferencedInLib();
    final offenders = <String>[];
    final skipped = <String>{};

    arbs.forEach((locale, entries) {
      entries.forEach((key, value) {
        final arms = _pluralArms(value);
        if (arms == null || (arms['zero'] ?? 'n/a').isNotEmpty) {
          return;
        }
        // An unused key cannot render blank anywhere. Deriving this instead of
        // hardcoding an allowlist means the exemption expires by itself the
        // moment someone starts calling the key.
        if (!usedKeys.contains(key)) {
          skipped.add(key);
          return;
        }
        offenders.add('$locale: $key = $value');
      });
    });

    printOnFailure('exempt (no call site in lib/): ${skipped.toList()..sort()}');
    expect(
      offenders,
      isEmpty,
      reason:
          'An empty zero arm renders an empty string at 0. Give it real text — '
          'usually the `other` wording for counts ("0 IPs"), or the number-less '
          'wording for countdowns ("Send again", not "Send again (0)").\n'
          '${offenders.join('\n')}',
    );
  });
}

/// `{locale: {key: value}}` for every ARB, metadata (`@key`) entries dropped.
Map<String, Map<String, String>> _loadArbs() {
  final out = <String, Map<String, String>>{};
  for (final file in Directory('lib/l10n').listSync().whereType<File>()) {
    if (!file.path.endsWith('.arb')) {
      continue;
    }
    final arb = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    out[file.uri.pathSegments.last] = {
      for (final e in arb.entries)
        if (!e.key.startsWith('@') && e.value is String) e.key: e.value as String,
    };
  }
  return out;
}

/// Splits an ICU plural body into its arms, or null if [value] is not one.
/// Brace-counting rather than a regex, so `{count}` inside an arm is kept.
Map<String, String>? _pluralArms(String value) {
  if (!value.startsWith('{count, plural,')) {
    return null;
  }
  final arms = <String, String>{};
  for (final m in RegExp(r'(zero|one|two|few|many|other)\s*\{').allMatches(value)) {
    var i = m.end;
    var depth = 1;
    final text = StringBuffer();
    while (i < value.length && depth > 0) {
      final char = value[i];
      if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;
        if (depth == 0) {
          break;
        }
      }
      text.write(char);
      i++;
    }
    arms[m.group(1)!] = text.toString();
  }
  return arms;
}

/// Localization keys called from app code. Plural keys always carry a
/// placeholder, so they generate a method and must be invoked as
/// `S.current.key(...)` — they can never reach the UI via `Tr.byKey`, which
/// makes this scan complete for the keys this file checks.
Set<String> _keysReferencedInLib() {
  final referenced = <String>{};
  final call = RegExp(r'S\.current\.([A-Za-z0-9_]+)');
  final sources = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.startsWith('lib/generated/'));

  for (final file in sources) {
    for (final m in call.allMatches(file.readAsStringSync())) {
      referenced.add(m.group(1)!);
    }
  }
  return referenced;
}
