import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/env.dart';

Map<String, String> _parseDotEnvFile() {
  const path = String.fromEnvironment('_DOTENV_FILE', defaultValue: '.env.dev');
  final lines = File(path).readAsLinesSync();
  final out = <String, String>{};
  for (final raw in lines) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }
    final eq = line.indexOf('=');
    if (eq <= 0) {
      continue;
    }
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }
    out[key] = value;
  }
  return out;
}

void main() {
  group('env file parsing', () {
    final file = _parseDotEnvFile();
    final actual = Env.asMap();

    print('File: $file');
    print('Actual: $actual');

    test('all keys are present', () {
      for (final key in actual.keys) {
        expect(file.containsKey(key), true, reason: 'missing key $key in .env file');
      }
      expect(
        const SetEquality().equals(file.keys.toSet(), actual.keys.toSet()),
        true,
        reason: 'key sets differ',
      );
    });

    test('all values match', () {
      for (final key in file.keys) {
        expect(
          file[key],
          actual[key],
          reason: 'mismatch for key $key between .env file and environment',
        );
      }
    });
  });
}
