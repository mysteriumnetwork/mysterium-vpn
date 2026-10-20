import 'package:mysterium_vpn/models/models.dart';

/// Platform push-messaging wrapper: permissions, the device token, and the
/// streams of notifications received and opened.
///
/// Also reports delivery/open events — see [reportEvent] — because they are
/// fire-and-forget with the token as their only input. Device registration and
/// deletion are keyed by the token too, but are half of a persisted state
/// machine, so they live in `NotifierService` driven by
/// `NotifierRegistrationStore`, which owns that record.
abstract class NotificationsRepository {
  Future<void> init();

  // ─── Permissions ─────────────────────────────────────────────────────────

  /// Shows the system prompt if it can still be shown. Returns whether
  /// notifications are authorized afterwards.
  Future<bool> requestPermission();

  /// Last known authorization state. Cached — [refreshPermissionStatus] pulls
  /// a fresh value from the platform.
  bool getPermissionStatus();

  /// Re-reads the platform's authorization state and emits it on
  /// [getPermissionStatusStream] if it changed. Called on app resume, since
  /// the user can flip the switch in system settings while we're backgrounded.
  ///
  /// Null means undetermined — the read failed, or the user has never been
  /// asked. Neither is a revocation, and callers that act destructively on a
  /// denial must treat only an explicit `false` as one.
  Future<bool?> refreshPermissionStatus();

  /// Whether the system prompt has never been answered, so requesting it would
  /// actually show something.
  Future<bool> canRequestPermission();

  Stream<bool> getPermissionStatusStream();

  Future<void> openAppNotificationsSettings();

  // ─── Device token ────────────────────────────────────────────────────────

  /// Current FCM token, or null before one has been minted. On iOS this stays
  /// null until APNs responds.
  String? get currentToken;

  /// Emits whenever the platform issues a new token.
  Stream<String> get tokenStream;

  // ─── Notifications ───────────────────────────────────────────────────────

  /// Dismisses anything this app still has in the notification tray. Leaves
  /// the device token alone.
  Future<void> cancelDisplayedNotifications();

  /// Notifications the user opened, from the foreground, the background, or a
  /// cold launch.
  Stream<PushNotification> getNotificationsStream();

  /// Notifications that arrived while the app was in the foreground.
  Stream<PushNotification> getReceivedStream();

  /// Reports a delivery/open for [notification] to the backend.
  ///
  /// Lives here rather than in a store because it is keyed by the device token,
  /// which this repository owns. Silently skipped when the token or the
  /// notification's campaign id is missing — there is nothing to attribute.
  ///
  /// Throws on a transport failure. The caller decides what that means: it is
  /// best-effort for the notification, but it is the only signal that Notifier
  /// is under-counting engagement.
  Future<void> reportEvent(PushNotification notification, NotifierEventType type);

  Future<void> dispose();
}
