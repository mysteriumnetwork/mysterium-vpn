import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';

const _delimiter = ',';

/// Converts JSON translation files in a directory to a single CSV file.
/// Use this if we need to export translations back to CSV format so that we can import and use it
/// in Google Sheet. This is not something we do regularly, but it's useful to have the script
/// available when needed.
void main(List<String> args) async {
  final [inputPath, outputPath] = args;
  final directory = Directory(inputPath);
  final csv = await _parseCSV(directory);

  final outputFile = File(outputPath);
  if (!outputFile.existsSync()) {
    outputFile.createSync(recursive: true);
  }
  await outputFile.writeAsString(csv);
  log('CSV written to $outputPath');
}

Future<String> _parseCSV(Directory directory) async {
  final files = directory.listSync();
  final keys = {
    'en',
    ...files
        .whereType<File>()
        .map((it) => it.path.split(Platform.pathSeparator).last.split('.').first)
        .sortedBy((it) => it),
  };

  final translations = Map.fromEntries(
    await Future.wait(
      keys.map((key) async {
        final file = files.firstWhere((it) => it.path.endsWith('$key.json')) as File;
        final normalized = await _normalizeFile(file);
        return MapEntry(key, normalized);
      }),
    ),
  );

  final translationKeys = translations.entries.first.value.keys.toList();

  final csv = [
    'key$_delimiter${keys.join(_delimiter)}',
    for (final key in translationKeys) _parseRow(key, translations),
  ];

  return csv.join('\n');
}

String _parseRow(String key, Map<String, Map<String, String>> translations) {
  final rowValues = translations.entries.map((entry) {
    final translation = entry.value[key] ?? '';
    // Escape double quotes by doubling them.
    final escaped = translation.replaceAll('"', '""');
    // Wrap in double quotes if it contains delimiter, quotes, or newlines.
    if (escaped.contains(_delimiter) || escaped.contains('"') || escaped.contains('\n')) {
      return '"$escaped"';
    } else {
      return escaped;
    }
  }).toList();

  return '$key$_delimiter${rowValues.join(_delimiter)}';
}

Future<Map<String, String>> _normalizeFile(File file) async {
  final raw = await file.readAsString();
  final json = jsonDecode(raw) as Map<String, dynamic>;

  final output = <String, String>{};

  // Recursively flatten a node into `output` under `prefix`.
  // `visitedAliases` prevents infinite alias loops (when a string points to another key that points back).
  void flatten(node, String prefix, Set<String> visitedAliases) {
    if (node is Map) {
      node.forEach((k, v) {
        final newKey = prefix.isEmpty ? k : '$prefix.$k';
        flatten(v, newKey.toString(), visitedAliases);
      });
    } else if (node is List) {
      output[prefix] = jsonEncode(node);
    } else if (node is String) {
      // Alias resolution: if the string matches a top-level key in root, resolve it.
      if (json.containsKey(node) && !visitedAliases.contains(node)) {
        // Mark this alias visited to avoid cycles.
        final nextVisited = {...visitedAliases, node};
        final referenced = json[node];
        if (referenced is Map) {
          // Inline the referenced map under current prefix (go one level deeper).
          flatten(referenced, prefix, nextVisited);
        } else if (referenced is List) {
          output[prefix] = jsonEncode(referenced);
        } else if (referenced is String) {
          // Continue resolving chains of aliases.
          flatten(referenced, prefix, nextVisited);
        } else {
          output[prefix] = referenced == null ? '' : referenced.toString();
        }
      } else {
        output[prefix] = node;
      }
    } else {
      // null or other scalar
      output[prefix] = node == null ? '' : node.toString();
    }
  }

  // Start flattening from the root map.
  json.forEach((k, v) {
    flatten(v, k, <String>{});
  });

  return output;
}
