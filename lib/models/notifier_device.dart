import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifier_device.freezed.dart';

part 'notifier_device.g.dart';

/// Platforms this app can register for push.
///
/// Only the three [current] can return. Notifier's own enum also has `windows`
/// and `web`, but firebase_messaging supports neither, so nothing here could
/// ever produce them — add a value when a platform actually ships.
enum NotifierPlatform {
  ios,
  android,
  macos;

  /// Platform this device registers as, or null where there is no push
  /// transport (Windows, Linux).
  static NotifierPlatform? current() {
    if (Platform.isIOS) {
      return NotifierPlatform.ios;
    }
    if (Platform.isAndroid) {
      return NotifierPlatform.android;
    }
    if (Platform.isMacOS) {
      return NotifierPlatform.macos;
    }
    return null;
  }
}

/// Device event types this app reports. Notifier also accepts `click`, which
/// nothing here sends — Android and Apple both surface a tap as an open.
enum NotifierEventType { open, delivered }

/// Version of the registration contract this build sends. Bump to invalidate
/// every stored registration and force a re-register on the next sync — e.g.
/// when the request body gains a field Notifier needs.
///
/// v2: macOS registers as `macos` rather than `ios`, which Notifier added.
const int kNotifierContractVersion = 2;

/// What this device still owes Notifier. A settled delete keeps no record at
/// all — it is cleared — so there is no `deleted` value.
enum NotifierSyncState { settled, pendingRegister, pendingDelete }

/// Locally persisted snapshot of the last device registration attempt.
///
/// [contractVersion] is a code constant — bumping it invalidates every stored
/// registration and forces a re-register on the next sync.
@freezed
abstract class NotifierRegistration with _$NotifierRegistration {
  const factory NotifierRegistration({
    required String externalUserId,
    required String token,
    required NotifierPlatform platform,
    required int contractVersion,
    @Default(NotifierSyncState.settled) NotifierSyncState state,
  }) = _NotifierRegistration;

  factory NotifierRegistration.fromJson(Map<String, dynamic> json) =>
      _$NotifierRegistrationFromJson(json);
}

extension NotifierRegistrationMatch on NotifierRegistration {
  /// Whether a call is still owed to Notifier for this record.
  bool get isPending => state != NotifierSyncState.settled;

  /// True when the registered identity is unchanged. Ignores [state], which
  /// tracks delivery rather than identity.
  bool matches(NotifierRegistration other) =>
      externalUserId == other.externalUserId &&
      token == other.token &&
      platform == other.platform &&
      contractVersion == other.contractVersion;
}
