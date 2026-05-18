import 'dart:io';

import 'package:flutter/services.dart';

class MailApp {
  const MailApp({required this.name, required this.identifier});

  /// Display name (e.g. "Gmail").
  final String name;

  /// Opaque platform identifier — URL scheme on iOS, bundle ID on macOS,
  /// package name on Android. Treat as a token; pass to [MailLauncher.open].
  final String identifier;
}

class MailLauncher {
  MailLauncher._();

  static const _channel = MethodChannel('network.mysterium/mail_launcher');

  /// Returns the list of installed mail apps on the current platform.
  /// Returns an empty list on platforms other than iOS, macOS, and Android.
  static Future<List<MailApp>> installed() async {
    if (!_supported) {
      return const [];
    }
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('listInstalled');
      if (raw == null) {
        return const [];
      }
      return raw
          .map(
            (entry) => MailApp(
              name: (entry['name'] as String?) ?? '',
              identifier: (entry['identifier'] as String?) ?? '',
            ),
          )
          .where((app) => app.identifier.isNotEmpty)
          .toList(growable: false);
    } on PlatformException {
      return const [];
    }
  }

  /// Launches [app] (typically to its inbox). Returns `true` on success.
  static Future<bool> open(MailApp app) async {
    if (!_supported) {
      return false;
    }
    try {
      final ok = await _channel.invokeMethod<bool>('open', {'identifier': app.identifier});
      return ok ?? false;
    } on PlatformException {
      return false;
    }
  }

  static bool get _supported => Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
}
