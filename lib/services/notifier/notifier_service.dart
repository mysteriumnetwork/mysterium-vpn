import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';

/// The Notifier public (SDK-facing) API surface.
///
/// Authenticated with a static public API key, not the user's access token —
/// see `notifierDioPOD`. Every method throws [NotifierException] on failure.
abstract class NotifierService {
  /// `POST /public/devices` — registers or updates (upserts by token).
  Future<void> registerDevice({
    required String externalUserId,
    required String token,
    required NotifierPlatform platform,
  });

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
