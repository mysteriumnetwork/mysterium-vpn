import 'package:mysterium_vpn/models/models.dart';

/// Platform push-messaging wrapper: permissions, the device token, and the
/// streams of notifications received and opened.
///
/// Also reports delivery/open events, because those are keyed by the device
/// token this class owns — see [reportEvent]. Device registration and user
/// attributes live in `NotifierService`, driven by `NotifierRegistrationStore`,
/// which needs the token for its dedupe fingerprint anyway.
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
  Future<bool> refreshPermissionStatus();

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

  /// Deletes the token so the old device→user association becomes
  /// undeliverable. A fresh token is minted on the next token request.
  Future<void> clearToken();

  // ─── Notifications ───────────────────────────────────────────────────────

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
  Future<void> reportEvent(PushNotification notification, NotifierEventType type);

  Future<void> dispose();
}
