import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mysterium_vpn/services/data/local/box_recovery.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('box_recovery_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('openBoxRecoverable', () {
    test('returns the box untouched when open and validation succeed', () async {
      final seedBox = await Hive.openBox<String>('healthy');
      await seedBox.put('a', '1');
      await seedBox.put('b', '2');
      await seedBox.close();

      final box = await openBoxRecoverable<Box<String>>(
        name: 'healthy',
        open: () => Hive.openBox<String>('healthy'),
        validateKey: (box, key) async => box.get(key),
      );

      expect(box.keys.toList(), ['a', 'b']);
      expect(box.get('a'), '1');
      expect(box.get('b'), '2');
    });

    test('skips per-key iteration when validateKey is null', () async {
      final seedBox = await Hive.openBox<String>('lazy_like');
      await seedBox.put('a', '1');
      await seedBox.close();

      final box = await openBoxRecoverable<Box<String>>(
        name: 'lazy_like',
        open: () => Hive.openBox<String>('lazy_like'),
        // validateKey omitted on purpose.
      );

      expect(box.get('a'), '1');
    });

    test('drops corrupt keys and keeps valid ones', () async {
      final seedBox = await Hive.openBox<String>('partial_corruption');
      await seedBox.put('good1', 'ok');
      await seedBox.put('bad', 'rotten');
      await seedBox.put('good2', 'ok');
      await seedBox.close();

      final box = await openBoxRecoverable<Box<String>>(
        name: 'partial_corruption',
        open: () => Hive.openBox<String>('partial_corruption'),
        validateKey: (box, key) async {
          if (key == 'bad') {
            throw StateError('simulated corruption for $key');
          }
        },
      );

      expect(box.keys.toSet(), {'good1', 'good2'});
      expect(box.get('good1'), 'ok');
      expect(box.get('good2'), 'ok');
      expect(box.containsKey('bad'), isFalse);
    });

    test('deletes the file and reopens fresh when open throws', () async {
      // Seed and then close so the .hive file is on disk.
      final seedBox = await Hive.openBox<String>('open_failure');
      await seedBox.put('a', '1');
      await seedBox.close();

      var attempts = 0;
      final box = await openBoxRecoverable<Box<String>>(
        name: 'open_failure',
        open: () async {
          attempts++;
          if (attempts == 1) {
            throw StateError('simulated open failure');
          }
          return Hive.openBox<String>('open_failure');
        },
      );

      expect(attempts, 2);
      // Recreated fresh — old data must be gone.
      expect(box.keys, isEmpty);
    });
  });

  group('safeRead', () {
    test('returns the value when read succeeds', () async {
      final box = await Hive.openBox<String>('safe_read_ok');
      await box.put('k', 'v');

      final result = await safeRead(box, 'k', () async => box.get('k'));

      expect(result, 'v');
      expect(box.containsKey('k'), isTrue);
    });

    test('returns null and deletes the key when read throws', () async {
      final box = await Hive.openBox<String>('safe_read_fail');
      await box.put('rotten', 'placeholder');
      await box.put('healthy', 'still_here');

      final result = await safeRead<String>(
        box,
        'rotten',
        () async => throw StateError('simulated corruption'),
      );

      expect(result, isNull);
      expect(box.containsKey('rotten'), isFalse);
      expect(box.get('healthy'), 'still_here');
    });
  });
}
