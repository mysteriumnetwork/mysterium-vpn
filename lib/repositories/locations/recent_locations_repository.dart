import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/storage.dart';

/// Single source of truth for the user's recently used locations.
///
/// Local only — recents are user history, not part of the server catalogue
/// that `LocationsRepository` owns, so there is nothing to fetch.
abstract class RecentLocationsRepository {
  /// The stored recents, most recent first.
  Future<List<VPNLocation>> load();

  /// Every later change to the stored recents.
  Stream<List<VPNLocation>> watch();

  /// Replaces the stored recents with [locations].
  Future<void> save(List<VPNLocation> locations);

  /// Empties the stored recents.
  Future<void> clear();
}

/// [RecentLocationsRepository] backed by [LocalDBService] (Hive).
class LocalRecentLocationsRepository implements RecentLocationsRepository {
  LocalRecentLocationsRepository(this._db);

  final LocalDBService _db;

  @override
  Future<List<VPNLocation>> load() => _db.getRecentLocations();

  @override
  Stream<List<VPNLocation>> watch() => _db.watchRecentLocations();

  @override
  Future<void> save(List<VPNLocation> locations) => _db.setRecentLocations(locations);

  @override
  Future<void> clear() => _db.setRecentLocations(const <VPNLocation>[]);
}
