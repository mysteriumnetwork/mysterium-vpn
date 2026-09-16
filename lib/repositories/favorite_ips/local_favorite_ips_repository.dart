import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/favorite_ips/favorite_ips_repository.dart';
import 'package:mysterium_vpn/services/services.dart';

/// [FavoriteIpsRepository] backed by [LocalDBService] (Hive) for the saved list
/// and [FavoriteIpsAvailabilityService] for availability.
class LocalFavoriteIpsRepository implements FavoriteIpsRepository {
  LocalFavoriteIpsRepository({
    required LocalDBService db,
    required FavoriteIpsAvailabilityService availabilityService,
  }) : _db = db,
       _availabilityService = availabilityService;

  /// How long a successful availability result is considered fresh. The tab
  /// refreshes on open, and that view can remount for reasons unrelated to
  /// favorites (the locations tree above it changing shape after a connect),
  /// so without this every remount would re-hit the endpoint.
  static const availabilityTtl = Duration(seconds: 30);

  final LocalDBService _db;
  final FavoriteIpsAvailabilityService _availabilityService;

  Future<Map<String, bool>?>? _inFlight;
  DateTime? _checkedAt;

  @override
  Future<List<FavoriteIp>> load() => _db.getFavoriteIps();

  @override
  Stream<List<FavoriteIp>> watch() => _db.watchFavoriteIps();

  @override
  Future<void> save(List<FavoriteIp> favorites) => _db.setFavoriteIps(favorites);

  @override
  Future<Map<String, bool>?> availability(List<String> ips, {bool force = false}) =>
      _inFlight ??= _availability(ips, force: force).whenComplete(() => _inFlight = null);

  Future<Map<String, bool>?> _availability(List<String> ips, {required bool force}) async {
    final checkedAt = _checkedAt;
    if (!force && checkedAt != null && DateTime.now().difference(checkedAt) < availabilityTtl) {
      return null;
    }

    final result = await _availabilityService.checkAvailability(ips);
    _checkedAt = DateTime.now();
    return result;
  }

  @override
  void invalidateAvailability() => _checkedAt = null;
}
