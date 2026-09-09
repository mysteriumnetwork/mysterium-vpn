// Repairs the ARB files after `intl_utils:localizely_download`.
//
// Localizely models plural arms per-locale from CLDR. `zero` is not a CLDR
// category for any locale we ship except Arabic, so a `zero{...}` arm has
// nowhere to live server-side and round-trips back as `zero{}` — silently
// emptying a translation that Dart's Intl.plural *does* use (it treats `zero:`
// as an explicit count == 0 case, not the CLDR category). The download also
// re-escapes non-BMP characters (flag emoji) into surrogate pairs.
//
// Rather than special-case plurals, this enforces one rule: a fetch may never
// replace a non-empty local string with an empty one. Re-encoding through
// dart:convert restores literal UTF-8 as a side effect.
//
// Run via `make localizely-fetch`, which snapshots the ARBs first and passes
// the snapshot as --baseline.
import 'dart:convert';
import 'dart:io';

const _l10nDir = 'lib/l10n';
final _emptyArm = RegExp(r'\b(zero|one|two|few|many|other)\{\}');

void main(List<String> args) {
  final baselineDir = _argValue(args, '--baseline');
  if (baselineDir == null) {
    stderr.writeln('usage: dart run tool/normalize_arb.dart --baseline <dir>');
    exit(64);
  }

  final restored = <String>[];
  final dropped = <String>[];
  var rewritten = 0;

  for (final file in _arbFiles(_l10nDir)) {
    final name = file.uri.pathSegments.last;
    final current = _decode(file.readAsStringSync());
    final baselineFile = File('$baselineDir/$name');
    final baseline = baselineFile.existsSync()
        ? _decode(baselineFile.readAsStringSync())
        : <String, dynamic>{};

    for (final key in current.keys) {
      final incoming = current[key];
      final previous = baseline[key];
      if (incoming is! String || previous is! String || previous.isEmpty) {
        continue;
      }
      final lostWholeString = incoming.trim().isEmpty;
      final lostArm = _emptyArm.hasMatch(incoming) && !_emptyArm.hasMatch(previous);
      if (lostWholeString || lostArm) {
        current[key] = previous;
        restored.add('$name:$key');
      }
    }

    for (final key in baseline.keys) {
      if (!current.containsKey(key) && !key.startsWith('@')) {
        dropped.add('$name:$key');
      }
    }

    final encoded = '${const JsonEncoder.withIndent('  ').convert(_ordered(current, baseline))}\n';
    if (encoded != file.readAsStringSync()) {
      file.writeAsStringSync(encoded);
      rewritten++;
    }
  }

  stdout.writeln('normalize_arb: rewrote $rewritten file(s)');
  if (restored.isNotEmpty) {
    stdout.writeln(
      'normalize_arb: kept ${restored.length} local value(s) the '
      'fetch would have emptied:',
    );
    for (final r in restored) {
      stdout.writeln('  $r');
    }
  }
  if (dropped.isNotEmpty) {
    stdout.writeln(
      'normalize_arb: WARNING — ${dropped.length} key(s) present '
      'locally but absent upstream (left removed):',
    );
    for (final d in dropped) {
      stdout.writeln('  $d');
    }
  }
}

/// Reorders [current] to follow [baseline]'s key order, so the download's own
/// ordering never shows up as diff noise. Keys new to this fetch are slotted in
/// alphabetically; each `@key` stays adjacent to the key it annotates.
Map<String, dynamic> _ordered(Map<String, dynamic> current, Map<String, dynamic> baseline) {
  bool isValue(String k) => k != '@@locale' && !k.startsWith('@');

  final order = [
    for (final k in baseline.keys)
      if (isValue(k) && current.containsKey(k)) k,
  ];
  final added = [
    for (final k in current.keys)
      if (isValue(k) && !baseline.containsKey(k)) k,
  ]..sort();

  for (final key in added) {
    final at = order.indexWhere((existing) => existing.compareTo(key) > 0);
    at < 0 ? order.add(key) : order.insert(at, key);
  }

  final out = <String, dynamic>{};
  if (current.containsKey('@@locale')) {
    out['@@locale'] = current['@@locale'];
  }
  for (final key in order) {
    out[key] = current[key];
    final meta = '@$key';
    if (current.containsKey(meta)) {
      out[meta] = current[meta];
    }
  }
  // Anything unexpected (stray metadata without a value key) is preserved.
  for (final entry in current.entries) {
    out.putIfAbsent(entry.key, () => entry.value);
  }
  return out;
}

String? _argValue(List<String> args, String flag) {
  final i = args.indexOf(flag);
  return (i >= 0 && i + 1 < args.length) ? args[i + 1] : null;
}

List<File> _arbFiles(String dir) =>
    (Directory(dir).listSync().whereType<File>().where((f) => f.path.endsWith('.arb'))).toList()
      ..sort((a, b) => a.path.compareTo(b.path));

Map<String, dynamic> _decode(String source) => Map<String, dynamic>.from(jsonDecode(source) as Map);
