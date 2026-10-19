import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';

/// The Notifier public (SDK-facing) API surface.
///
/// Authenticated with a static public API key, not the user's access token —
/// see `notifierDioPOD`. Every method throws [NotifierException] on failure.
abstract class NotifierService {
  /// `POST /public/devices` — registers or updates.
  ///
  /// Notifier identifies a device by (`token`, `externalUserId`); there is no
  /// device id. So a re-register with an unchanged pair updates that row in
  /// place, while a refreshed token looks like a new device and leaves the old
  /// row behind for Notifier to reap when FCM rejects it.
  Future<void> registerDevice({
    required String externalUserId,
    required String token,
    required NotifierPlatform platform,
  });

  /// `DELETE /public/devices` — unregisters the device.
  ///
  /// Notifier always answers 204, so this is idempotent and safe to retry.
  /// Afterwards the device receives nothing at all — broadcast campaigns
  /// included — until [registerDevice] runs again.
  ///
  /// [externalUserId] is optional for the API but we always send it: without
  /// it, a delayed sign-out request would switch off pushes for whoever signed
  /// in on the device next.
  Future<void> deleteDevice({required String token, required String externalUserId});

  /// `PUT /public/users/{externalId}/attributes` — shallow JSONB merge.
  ///
  /// 404s for a user Notifier has never seen, so only call this after a
  /// successful [registerDevice].
  Future<void> mergeAttributes({
    required String externalUserId,
    required Map<String, Object?> attributes,
  });

  /// `POST /public/events` — records a delivery/open/click against a device.
  Future<void> recordEvent({
    required String token,
    required NotifierEventType type,
    String? campaignId,
    String? journeyStepId,
  });
}
