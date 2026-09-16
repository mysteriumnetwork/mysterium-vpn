import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/locations/locations_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

/// Reports whether the user is currently authenticated, so the repository can
/// refuse to cache an unauthenticated response.
typedef IsAuthenticated = bool Function();

/// [LocationsRepository] backed by the `vpn_api` connection endpoint for the
/// feed and [LocalDBService] (Hive) for the cache.
class RestLocationsRepository implements LocationsRepository {
  RestLocationsRepository({
    required Connection connection,
    required LocalDBService db,
    required Talker logger,
    required IsAuthenticated isAuthenticated,
  }) : _connection = connection,
       _db = db,
       _logger = logger,
       _isAuthenticated = isAuthenticated;

  final Connection _connection;
  final LocalDBService _db;
  final Talker _logger;
  final IsAuthenticated _isAuthenticated;

  @override
  Future<VPNLocations> fetch(IPType ipType) async {
    final wasAuthenticated = _isAuthenticated();

    try {
      final response = await _connection.connectionLocations(
        ipType: switch (ipType) {
          IPType.closest => null,
          _ => ipType.key,
        },
      );
      final config = response.data;
      if (config == null) {
        throw Exception('No data found');
      }

      final locations = config.map((it) => VPNLocation.fromAPICountry(it, ipType: ipType)).toList();
      final data = VPNLocations(locations: locations);

      // Skip persisting unauth responses — they mark every location
      // is_available=false and would poison the cache for the next reader.
      // Check both pre- and post-request auth state to also catch a logout
      // that races a request that's already in flight.
      if (wasAuthenticated && _isAuthenticated()) {
        await _db.setLocations(data, type: ipType);
      }
      return data;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<VPNLocations> watch(IPType ipType) async* {
    final cached = await _db.getLocations(ipType);

    if (cached != null && cached.isNotEmpty) {
      yield cached;
    }

    yield* _db.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _db.setLocations(VPNLocations(), type: IPType.residential),
      _db.setLocations(VPNLocations(), type: IPType.datacenter),
    ]);
  }
}
