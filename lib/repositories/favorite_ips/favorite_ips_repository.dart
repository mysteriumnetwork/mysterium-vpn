import 'package:mysterium_vpn/models/models.dart';

/// Single source of truth for the user's favorite IPs: the saved list plus
/// their backend availability.
abstract class FavoriteIpsRepository {
  /// The saved favorites, most recent first.
  Future<List<FavoriteIp>> load();

  /// Every later change to the saved favorites.
  Stream<List<FavoriteIp>> watch();

  /// Replaces the saved favorites with [favorites].
  Future<void> save(List<FavoriteIp> favorites);

  /// Availability per IP, or `null` when the previous result is still fresh
  /// and [force] is false — callers keep whatever they already had, which is
  /// how a locally marked-unavailable IP survives a remount.
  ///
  /// Concurrent callers share one request. Throws if the lookup fails.
  Future<Map<String, bool>?> availability(List<String> ips, {bool force = false});

  /// Drops the cached availability result, so the next lookup hits the backend.
  void invalidateAvailability();
}
