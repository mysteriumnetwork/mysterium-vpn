import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge_keys.g.dart';

/// Resolves translation keys that are only known at runtime (country codes,
/// theme modes, ConfigCat-driven plan-feature keys, enum-derived keys) to their
/// generated [S] string.
///
/// Replaces easy_localization's dynamic `someKey.tr()`. Only no-argument keys
/// are supported; keys with placeholders are `S` methods and must be called
/// directly at their call sites.
class Tr {
  const Tr._();

  /// Returns the translation for [key], or [key] itself when unknown. A miss is
  /// logged in debug so typos surface during development; use [byKeyOrNull] for
  /// call sites that legitimately probe for a key or want an explicit fallback.
  static String byKey(String key) {
    final resolve = kTrBridge[key];
    if (resolve == null) {
      assert(() {
        debugPrint('Tr.byKey: unknown key "$key" (returning it verbatim)');
        return true;
      }(), 'Tr.byKey miss');
      return key;
    }
    return resolve(S.current);
  }

  /// Like [byKey] but returns `null` when the key is unknown — for callers that
  /// probe for a key's existence or supply their own fallback. No debug log.
  static String? byKeyOrNull(String key) => kTrBridge[key]?.call(S.current);
}
