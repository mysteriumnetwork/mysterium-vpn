import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/favorite_ips/favorite_ips_repository.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
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
  List<String>? _inFlightIps;
  DateTime? _checkedAt;

  /// Bumped by [invalidateAvailability]. A request that completes against an
  /// older generation still returns its result, but does not refresh the
  /// window — it never covered the current list.
  int _generation = 0;

  @override
  Future<List<FavoriteIp>> load() => _db.getFavoriteIps();

  @override
  Stream<List<FavoriteIp>> watch() => _db.watchFavoriteIps();

  @override
  Future<void> save(List<FavoriteIp> favorites) => _db.setFavoriteIps(favorites);

  @override
  Future<Map<String, bool>?> availability(List<String> ips, {bool force = false}) {
    // Checked before the dedup so a fresh result costs a field compare rather
    // than two futures — the favorites tab remounts often.
    final checkedAt = _checkedAt;
    if (!force && checkedAt != null && DateTime.now().difference(checkedAt) < availabilityTtl) {
      return Future.value();
    }
    // Only share a request that asked about the same IPs — a caller with a
    // different list is asking a different question.
    final inFlight = _inFlight;
    if (inFlight != null && listEquals(_inFlightIps, ips)) {
      return inFlight;
    }

    _inFlightIps = List<String>.unmodifiable(ips);
    return _inFlight = _availability(ips, _generation).whenComplete(() {
      _inFlight = null;
      _inFlightIps = null;
    });
  }

  Future<Map<String, bool>?> _availability(List<String> ips, int generation) async {
    final result = await _availabilityService.checkAvailability(ips);
    // The result is still valid for the IPs it asked about, so it is returned
    // either way. But if the list changed or the session ended while it was in
    // flight it must not restore the freshness window, or the next caller
    // would be served a cached answer that never covered the current list.
    if (generation == _generation) {
      _checkedAt = DateTime.now();
    }
    return result;
  }

  @override
  void invalidateAvailability() {
    _generation++;
    _checkedAt = null;
    _inFlight = null;
    _inFlightIps = null;
  }
}
