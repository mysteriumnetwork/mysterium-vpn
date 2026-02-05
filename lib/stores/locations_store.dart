import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

/// The `_LocationsStore` class is responsible for managing and caching VPN location data.
/// It provides functionality for:
/// - Loading and caching location lists (datacenter and residential).
/// - Keeping an up-to-date in-memory view of locations using MobX.
/// - Auto-refreshing location data from the backend at a configurable interval.
/// - Providing filtered and computed projections for the UI
abstract class _LocationsStore with Store {
  _LocationsStore(
    this._connection,
    this._filter,
    this._db,
    this._locationsService,
    this._logger,
    this._config,
    this._query,
    this._locale,
  ) {
    // Attach watchers to listen for database changes and update observable futures.
    // These watchers are all disposed of in the dispose method to avoid memory leaks.
    _streamSubscriptions = [
      // Watch for changes in residential locations and update the value of observable future.
      _watch(IPType.residential).listen(
        (it) => _residentialLocationsFuture = ObservableFuture.value(it),
      ),
      // Watch for changes in datacenter locations and update the value of observable future.
      _watch(IPType.datacenter).listen(
        (it) => _dcLocationsFuture = ObservableFuture.value(it),
      ),
      // Sets up periodic auto-refresh of location data based on the configured interval.
      // This ensures the app maintains up-to-date location information without user intervention.
      Stream.periodic(_config.locationsRefreshInterval).listen((_) => refresh()),
    ];
  }

  final Connection _connection;
  final FilterService _filter;
  final LocalDBService _db;
  final LocationsService _locationsService;
  final Talker _logger;

  final RemoteConfigStore _config;
  final LocationsQueryStore _query;
  final LocaleStore _locale;

  late final List<StreamSubscription<Object?>> _streamSubscriptions;

  /// Observable future for datacenter locations. By default, it fetches locations from remote API.
  @readonly
  late ObservableFuture<VPNLocations> _dcLocationsFuture =
      ObservableFuture(_fetch(IPType.datacenter));

  /// Observable future for residential locations. By default, it fetches locations from remote API.
  @readonly
  late ObservableFuture<VPNLocations> _residentialLocationsFuture =
      ObservableFuture(_fetch(IPType.residential));

  /// Computed observable for the active locations future based on the selected IP type.
  @computed
  ObservableFuture<VPNLocations> get locationsFuture => switch (_query.ipType) {
        IPType.datacenter => _dcLocationsFuture,
        _ => _residentialLocationsFuture,
      };

  /// Computed observable for the set of available countries across all locations.
  @computed
  Set<String> get countryCodes => {
        ...?_dcLocationsFuture.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
        ...?_residentialLocationsFuture.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
      };

  /// Computed observable for the list of locations, filtered based on the search keyword.
  @computed
  List<VPNLocation> get locations {
    final value = locationsFuture.value?.locations;
    if (value != null) {
      return _filter.filterLocations(
        value,
        keyword: _query.searchTrimmed,
        locale: _locale.currentLocale.languageCode.toLowerCase(),
        shouldSortList: true,
      );
    }
    return [];
  }

  /// Computed observable for the list of top locations, filtered based on the search keyword.
  @computed
  List<VPNLocation> get topLocations {
    final value = locationsFuture.value?.topLocations;
    if (value != null) {
      return _filter.filterLocations(
        value,
        keyword: _query.searchTrimmed,
        locale: _locale.currentLocale.languageCode.toLowerCase(),
        shouldSortList: true,
      );
    }
    return [];
  }

  /// Computed observable indicating whether the locations list is empty.
  /// Returns null if locations are still loading.
  @computed
  bool? get isEmpty => locationsFuture.value == null ? null : locations.isEmpty;

  @computed
  List<IPType> get locationTypes => [
        if (_dcLocationsFuture.value?.isNotEmpty ?? false) IPType.datacenter,
        if (_residentialLocationsFuture.value?.isNotEmpty ?? false) IPType.residential,
      ];

  /// Fetches location data from the backend API for the specified IP type.
  /// It maps the raw API response to the internal `VPNLocations` model, persists it to the local database, and returns the data.
  /// If an error occurs during the fetch or mapping process, it logs the error and rethrows it.
  /// Even if error occurs, previously cached locations remain available for use. Database is only updated on successful fetch.
  @action
  Future<VPNLocations> _fetch(IPType ipType) async {
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

      await _db.setLocations(data, type: ipType);
      return data;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  /// Stream current + future location sets for a given IP type.
  /// Emits synchronously from cache (if present) then live updates from DB.
  /// This ensures the UI can reactively update as location data changes.
  Stream<VPNLocations> _watch(IPType ipType) async* {
    final cached = await _db.getLocations(ipType);

    // Emit cached locations first if available for immediate UI responsiveness.
    if (cached != null && cached.isNotEmpty) {
      yield cached;
    }

    // Then yield live updates from the database.
    yield* _db.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  /// Refreshes location data from the backend for the specified IP type.
  /// If no IP type is provided, it refreshes the currently selected type.
  /// If a refresh is already in progress, it returns the existing future to avoid duplicate requests.
  /// This method is useful for ensuring the app has the latest location data, either on-demand or via auto-refresh.
  @action
  Future<void> refresh([IPType? ipType]) async {
    try {
      ipType ??= _query.ipType;
      if (ipType == IPType.closest) {
        return;
      }

      await switch (ipType) {
        IPType.datacenter => _dcLocationsFuture,
        IPType.residential => _residentialLocationsFuture,
        _ => throw Exception('Invalid IP type for refresh'),
      };

      await _fetch(ipType);
    } on ApiException catch (_) {
      // do nothing. previously cached locations remain available for use
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
    }
  }

  /// Refreshes all location data (both datacenter and residential) from the backend.
  /// This method is useful for ensuring the app has the latest location data across all types, either on-demand or via auto-refresh.
  /// If a refresh is already in progress, it waits for the existing future to complete before starting a new one.
  /// This prevents overlapping refresh operations.
  @action
  Future<void> refreshAll() => Future.wait([
        refresh(IPType.datacenter),
        refresh(IPType.residential),
      ]);

  /// Finds a location by its ID, optionally filtering by country code and IP type.
  /// If no exact match is found, it attempts to find a country-level match.
  Future<VPNLocation?> findById(
    String id, {
    String? countryCode,
    IPType ipType = IPType.datacenter,
  }) async {
    if (ipType == IPType.closest) {
      return null;
    }

    final data = await switch (ipType) {
      IPType.datacenter => _dcLocationsFuture,
      IPType.residential => _residentialLocationsFuture,
      _ => throw Exception('Invalid IP type for findById'),
    };

    final locations = data.allLocationsFlattened;

    var match = locations.firstWhereOrNull((it) {
      if (countryCode != null) {
        return it.id == id && it.countryCode == countryCode;
      }
      return it.id == id;
    });

    // if no city is in our list, we try to find a country
    return match ??=
        locations.firstWhereOrNull((it) => it.isCountry && it.countryCode == (countryCode ?? id));
  }

  /// Finds the closest VPN location based on latency to the user's current region.
  /// It first determines the closest region by pinging known hosts, then selects a random location from the top countries in that region.
  Future<VPNLocation?> findClosest([IPType? type]) async {
    final [datacenter, residential] = await Future.wait([
      _dcLocationsFuture,
      _residentialLocationsFuture,
    ]);

    final locations = switch (type) {
      IPType.datacenter => datacenter.allLocations,
      IPType.residential => residential.allLocations,
      _ => {...datacenter.allLocations, ...residential.allLocations},
    };

    return _locationsService.closestLocation(locations.toList(), type: type);
  }

  VPNLocation? findParent(VPNLocation location) {
    if (location.isCountry) {
      return null;
    }

    final locations = switch (location.ipType) {
      IPType.datacenter => _dcLocationsFuture.value?.allLocations,
      IPType.residential => _residentialLocationsFuture.value?.allLocations,
      _ => null,
    };

    return locations?.firstWhereOrNull(
      (it) => it.isCountry && it.countryCode == location.countryCode,
    );
  }

  /// Inserts invalid locations into the current list of locations for testing purposes.
  /// This is useful for QA and development to simulate scenarios with unavailable or malformed locations.
  /// It adds one invalid country location to both datacenter and residential lists.
  @action
  void insertInvalidLocations() {
    final invalidResidential = _residentialLocationsFuture.value?.copyWith(
      locations: [
        Mocks.createInvalidCountry(ipType: IPType.residential),
        ...?_residentialLocationsFuture.value?.locations,
      ],
    );

    final invalidDatacenter = _dcLocationsFuture.value?.copyWith(
      locations: [
        Mocks.createInvalidCountry(ipType: IPType.datacenter),
        ...?_dcLocationsFuture.value?.locations.map(
          (it) {
            if (it.isCountry && it.countryCode == 'US') {
              return it.copyWith(
                children: [
                  Mocks.createInvalidCity(ipType: IPType.datacenter, countryCode: 'US'),
                  ...?it.children,
                ],
              );
            }
            return it;
          },
        ),
      ],
    );

    if (invalidResidential != null) {
      _residentialLocationsFuture = ObservableFuture.value(invalidResidential);
    }

    if (invalidDatacenter != null) {
      _dcLocationsFuture = ObservableFuture.value(invalidDatacenter);
    }
  }

  /// Clears all stored locations (both datacenter and residential) from the local database.
  /// This is primarily used for development purposes to reset cached data.
  @action
  Future<void> clear() async {
    await Future.wait([
      _db.setLocations(VPNLocations(), type: IPType.residential),
      _db.setLocations(VPNLocations(), type: IPType.datacenter),
    ]);
  }

  /// Disposes of resources such as debouncers and stream subscriptions to prevent memory leaks.
  FutureOr<void> dispose() async {
    // Cancel all stream subscriptions
    await Future.wait(_streamSubscriptions.map((it) => it.cancel()));
  }
}
