import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';

/// Single source of truth for VPN locations: fetches them from the backend,
/// caches them locally, and streams the cache to observers.
abstract class LocationsRepository {
  /// Fetches locations of [ipType] from the backend and caches them.
  ///
  /// Throws on failure; the existing cache is left untouched so callers can
  /// keep showing the previous data.
  Future<VPNLocations> fetch(IPType ipType);

  /// Current cached locations for [ipType], then every later cache update.
  ///
  /// Emits synchronously from cache first (when non-empty) so the UI has data
  /// before the first network round trip completes.
  Stream<VPNLocations> watch(IPType ipType);

  /// Empties the cache for every IP type.
  Future<void> clear();
}
