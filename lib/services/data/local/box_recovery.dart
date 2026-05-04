import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Opens a Hive box and recovers from corruption.
///
/// Hive raises "Could not read value from box. Maybe your box is corrupted."
/// at read time, not open time, so opening successfully is not enough.
/// On open failure the on-disk file is deleted and the box is reopened.
/// When [validateKey] is provided, every key is read individually — keys
/// that throw are deleted via [safeRead] so valid entries survive.
/// Pass `validateKey: null` for lazy boxes (or any box where reading every
/// value at open time would be expensive) and use [safeRead] at call sites.
Future<B> openBoxRecoverable<B extends BoxBase<Object?>>({
  required String name,
  required Future<B> Function() open,
  Future<void> Function(B box, Object key)? validateKey,
}) async {
  B box;
  try {
    box = await open();
  } catch (e) {
    debugPrint('Hive box "$name" failed to open, recreating: $e');
    Sentry.captureException(
      e,
      stackTrace: StackTrace.current,
      hint: Hint.withMap({'hint': 'Deleting and recreating Hive box "$name"'}),
    );
    await Hive.deleteBoxFromDisk(name);
    box = await open();
  }
  if (validateKey != null) {
    final keys = box.keys.cast<Object>().toList();
    for (final key in keys) {
      await safeRead(box, key, () => validateKey(box, key));
    }
  }
  return box;
}

/// Reads a key via [read] and deletes it from [box] if reading throws.
/// Returns the value on success, `null` if the key was corrupt and dropped.
Future<T?> safeRead<T>(BoxBase<Object?> box, Object key, Future<T?> Function() read) async {
  try {
    return await read();
  } catch (e) {
    debugPrint('Corrupt key "$key" in Hive box "${box.name}", deleting: $e');
    Sentry.captureException(
      e,
      stackTrace: StackTrace.current,
      hint: Hint.withMap({'hint': 'Deleting corrupt key "$key" from "${box.name}"'}),
    );
    await box.delete(key);
    return null;
  }
}
