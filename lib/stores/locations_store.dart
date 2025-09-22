import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/services/location/ping.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
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
/// - Providing filtered and computed projections for the UI (e.g., recent, top, search, random, closest locations).
/// - Persisting user preferences such as recent locations and chosen IP type.
abstract class _LocationsStore with Store {
  _LocationsStore(
    this._apiConnection,
    this._filterService,
    this._analyticsStore,
    this._remoteConfigStore,
    this._prefs,
    this._localDB,
    this._logger,
    this._localeStore,
    this._ping,
  ) {
    // React to locale changes and reset the search keyword to avoid stale matches.
    reaction((_) => _localeStore.currentLocale, (locale) {
      if (_searchKeyword.isNotEmpty) {
        setLocationKeyword('');
      }
    });

    // Start the periodic auto-refresh cycle.
    _autoRefresh();

    // Attach watchers to listen for database changes and update observable futures. These watchers are all disposed of in the dispose method to avoid memory leaks.
    _subs.addAll([
      // Watch for changes in residential locations and update the value of observable future.
      _watch(IPType.residential).listen(
        (it) => _residentialLocationsFuture = _residentialLocationsFuture.replaceOrReset(
          Future.value(it),
        ),
      ),
      // Watch for changes in datacenter locations and update the value of observable future.
      _watch(IPType.datacenter).listen(
        (it) => _dcLocationsFuture = _dcLocationsFuture.replaceOrReset(
          Future.value(it),
        ),
      ),
      // Watch for changes in recent locations and update the value of observable future.
      _localDB.watchRecentLocations().listen(
            (it) => _recentLocationsFuture = _recentLocationsFuture.replaceOrReset(
              Future.value(it),
            ),
          ),
    ]);
  }

  final List<StreamSubscription<Object?>> _subs = [];
  final Connection _apiConnection;
  final FilterService _filterService;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final LocaleStore _localeStore;
  final SharedPreferenceService _prefs;
  final LocalDBService _localDB;
  final Talker _logger;
  final Ping? _ping;

  final Debouncer _debouncer = Debouncer();
  StreamSubscription<dynamic>? _autoRefreshSubscription;

  /// Flag to clear fetched locations (used for development purposes).
  @readonly
  bool _clearFetchedLocations = false;

  /// The currently selected VPN location.
  @observable
  VPNLocation? selectedLocation;

  /// Observable future for datacenter locations. By default, it fetches locations from remote API.
  @readonly
  late ObservableFuture<VPNLocations> _dcLocationsFuture =
      ObservableFuture(_fetchLocations(IPType.datacenter));

  /// Observable future for residential locations. By default, it fetches locations from remote API.
  @readonly
  late ObservableFuture<VPNLocations> _residentialLocationsFuture =
      ObservableFuture(_fetchLocations(IPType.residential));

  /// Observable future for recent locations. By default, it fetches recent locations from local database.
  @readonly
  late ObservableFuture<List<VPNLocation>> _recentLocationsFuture =
      ObservableFuture(_localDB.getRecentLocations());

  /// Observable future for refresh operations. It is used to track the status of ongoing refreshes.
  @readonly
  late ObservableFuture<void> _refreshFuture = ObservableFuture.value(null);

  @readonly
  String _searchKeyword = '';

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  /// Computed observable for the active locations future based on the selected IP type.
  @computed
  ObservableFuture<VPNLocations> get locationsFuture => switch (_ipType) {
        IPType.datacenter => _dcLocationsFuture,
        _ => _residentialLocationsFuture,
      };

  /// Computed observable for the set of available countries across all locations.
  @computed
  Set<String> get availableCountries => {
        ...?_dcLocationsFuture.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
        ...?_residentialLocationsFuture.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
      };

  /// Sets the `_clearFetchedLocations` flag, which is only allowed in the development environment (in QA Toolbox).
  @action
  // ignore: avoid_positional_boolean_parameters
  void setClearFetchedLocations(bool value) {
    if (!Env.flavor.isDev) {
      throw Exception('clearFetchedLocations can only be set in dev environment');
    }
    _clearFetchedLocations = value;
  }

  /// Computed observable for the list of recent locations, filtered and sorted.
  /// It cross-references with available locations to ensure we only show recent locations that are currently available.
  /// Also applies search keyword filtering.
  @computed
  List<VPNLocation> get recentLocations {
    final value = _recentLocationsFuture.value ?? const <VPNLocation>[];
    if (value.isEmpty) {
      return [];
    }
    final availableLocations = {
      ...?_dcLocationsFuture.value?.allLocationsFlattened,
      ...?_residentialLocationsFuture.value?.allLocationsFlattened,
    };

    return _filterService.filterRecentLocations(
      value,
      availableLocations: availableLocations,
      keyword: _searchKeyword,
      locale: _localeStore.currentLocale.languageCode.toLowerCase(),
    );
  }

  /// Computed observable for the list of locations, filtered based on the search keyword.
  @computed
  List<VPNLocation> get locations {
    final value = locationsFuture.value?.locations;
    if (value != null) {
      return _filterService.filterLocations(
        value,
        keyword: _searchKeyword,
        locale: _localeStore.currentLocale.languageCode.toLowerCase(),
      );
    }
    return [];
  }

  /// Computed observable for the list of top locations, filtered based on the search keyword.
  @computed
  List<VPNLocation> get topLocations {
    final value = locationsFuture.value?.topLocations;
    if (value != null) {
      return _filterService.filterLocations(
        value,
        keyword: _searchKeyword,
        locale: _localeStore.currentLocale.languageCode.toLowerCase(),
      );
    }
    return [];
  }

  /// Computed observable indicating whether the locations list is empty.
  /// Returns null if locations are still loading.
  @computed
  bool? get isEmpty => locationsFuture.value == null ? null : locations.isEmpty;

  /// Computed observable for a random location, prioritizing recent locations.
  /// If no recent locations exist, returns a placeholder "closest" location if any locations are available.
  /// Returns null if no locations are available.
  /// This is useful for suggesting a location when the user has no recent selections.
  /// The "closest" location acts as a prompt for the user to connect to the nearest server.
  @computed
  VPNLocation? get randomLocation {
    if (recentLocations.isNotEmpty) {
      return recentLocations.first;
    }

    final isLocationsNotEmpty = (_dcLocationsFuture.value?.isNotEmpty ?? false) &&
        (_residentialLocationsFuture.value?.isNotEmpty ?? false);

    if (isLocationsNotEmpty) {
      return const VPNLocation(
        id: '',
        translations: {},
        ipType: IPType.closest,
        countryCode: '',
      );
    }
    return null;
  }

  /// Finds a location by its ID, optionally filtering by country code and IP type.
  /// If no exact match is found, it attempts to find a country-level match.
  @action
  VPNLocation findLocation(
    String id, {
    String? countryCode,
    IPType ipType = IPType.datacenter,
  }) {
    final locations = switch (ipType) {
          IPType.datacenter => _dcLocationsFuture.value?.allLocationsFlattened,
          IPType.residential => _residentialLocationsFuture.value?.allLocationsFlattened,
          _ => null,
        } ??
        const <VPNLocation>[];

    var match = locations.firstWhereOrNull((it) {
      if (countryCode != null) {
        return it.id == id && it.countryCode == countryCode;
      }
      return it.id == id;
    });

    // if no city is in our list, we try to find a country
    match ??= locations.firstWhereOrNull(
      (it) => it.isCountry && it.countryCode == (countryCode ?? id),
    );

    // If no match is found, create a placeholder location.
    match ??= VPNLocation(
      id: id,
      ipType: ipType,
      translations: const {},
      countryCode: countryCode ?? id,
    );

    return match;
  }

  /// Finds the closest VPN location based on latency to the user's current region.
  /// It first determines the closest region by pinging known hosts, then selects a random location from the top countries in that region.
  Future<VPNLocation?> closestLocation([IPType? type]) async {
    final closestRegion = await this.closestRegion(type);

    if (closestRegion == null) {
      return null;
    }

    final closestLocations = countriesToLocations(closestRegion.topCountries, type);
    if (closestLocations.isEmpty) {
      return null;
    }

    final r = Random();
    return closestLocations[r.nextInt(closestLocations.length)];
  }

  /// Determines the closest connection region by pinging known hosts and measuring latency.
  /// Optionally filters regions by IP type (datacenter or residential).
  /// Returns null if no regions are available.
  /// This method is useful for selecting the optimal server region for the user based on network performance.
  Future<ConnectionRegion?> closestRegion([IPType? type]) async {
    final connectionConfigRegions = (await _apiConnection.connectionConfigRegions(
      ipType: switch (type) {
        IPType.datacenter => 'hosting',
        IPType.residential => 'residential',
        _ => null,
      },
    ))
        .data!;
    if (connectionConfigRegions.regions.isEmpty) {
      return null;
    }

    return _detectClosestRegion(connectionConfigRegions.regions);
  }

  /// Stream current + future location sets for a given IP type.
  /// Emits synchronously from cache (if present) then live updates from DB.
  /// This ensures the UI can reactively update as location data changes.
  Stream<VPNLocations> _watch(IPType ipType) async* {
    final cached = _localDB.getLocations(_ipType);

    // Emit cached locations first if available for immediate UI responsiveness.
    if (cached != null && cached.isNotEmpty) {
      yield cached;
    }

    // Then yield live updates from the database.
    yield* _localDB.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  /// Detects the closest connection region by pinging each region's host and measuring latency.
  /// Returns the region with the lowest median latency.
  /// This method is useful for optimizing server selection based on network performance.
  Future<ConnectionRegion> _detectClosestRegion(List<ConnectionRegion> regions) async {
    // Ensures all pings complete before finding the lowest latency
    final regionsWithLatencies = await Future.wait(
      regions.map((region) async {
        final ping = _ping ?? Ping(region.host, 80);
        return RegionWithLatency(region, await ping.latencyMedian());
      }),
    );

    // Find region with lowest latency
    final region = regionsWithLatencies.reduce((a, b) => a.latency < b.latency ? a : b);
    return region.region;
  }

  /// Sets up periodic auto-refresh of location data based on the configured interval.
  /// This ensures the app maintains up-to-date location information without user intervention.
  Future<void> _autoRefresh() async {
    await _remoteConfigStore.configFuture;
    _autoRefreshSubscription = Stream.periodic(_remoteConfigStore.locationsRefreshInterval).listen(
      (_) => refresh(),
    );
  }

  /// Refreshes location data from the backend for the specified IP type.
  /// If no IP type is provided, it refreshes the currently selected type.
  /// If a refresh is already in progress, it returns the existing future to avoid duplicate requests.
  /// This method is useful for ensuring the app has the latest location data, either on-demand or via auto-refresh.
  @action
  Future<void> refresh([IPType? ipType]) async {
    if (_refreshFuture.status == FutureStatus.pending) {
      return _refreshFuture;
    }
    _refreshFuture = ObservableFuture(_fetchLocations(ipType ?? _ipType));
    await _refreshFuture;
  }

  /// Refreshes all location data (both datacenter and residential) from the backend.
  /// This method is useful for ensuring the app has the latest location data across all types, either on-demand or via auto-refresh.
  /// If a refresh is already in progress, it waits for the existing future to complete before starting a new one.
  /// This prevents overlapping refresh operations.
  @action
  Future<void> refreshAll() async {
    await _refreshFuture;
    _refreshFuture = ObservableFuture(
      Future.wait([
        _fetchLocations(IPType.datacenter),
        _fetchLocations(IPType.residential),
      ]),
    );
    await _refreshFuture;
  }

  /// Fetches location data from the backend API for the specified IP type.
  /// It maps the raw API response to the internal `VPNLocations` model, persists it to the local database, and returns the data.
  /// If an error occurs during the fetch or mapping process, it logs the error and rethrows it.
  /// Even if error occurs, previously cached locations remain available for use. Database is only updated on successful fetch.
  @action
  Future<VPNLocations> _fetchLocations(IPType ipType) async {
    try {
      final response = await _apiConnection.connectionLocations(
        ipType: switch (ipType) {
          IPType.datacenter => 'hosting',
          IPType.residential => 'residential',
          _ => null,
        },
      );
      final connectionConfig = response.data;
      if (connectionConfig == null) {
        throw Exception('No data found');
      }

      if (_clearFetchedLocations) {
        connectionConfig.clear();
      }

      final locations = _mapLocations(connectionConfig, ipType);
      final data = VPNLocations(topLocations: [], locations: locations);

      await _localDB.setLocations(data, type: ipType);
      return data;
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  /// Adds a location to the recent locations list, ensuring no duplicates and maintaining a maximum of 5 entries.
  /// It also updates the selected IP type based on the added location.
  /// If the location is not part of the currently available locations (based on IP type), it is skipped.
  /// This method is useful for tracking user preferences and providing quick access to frequently used locations.
  @action
  Future<void> addRecentLocation(VPNLocation location) async {
    if (_shouldSkipLocation(location)) {
      return;
    }
    if (location.id.isNotEmpty) {
      if (recentLocations.contains(location)) {
        recentLocations.remove(location);
      }
      recentLocations.insert(0, location);
      if (recentLocations.length > 5) {
        recentLocations.removeLast();
      }
      await _localDB.setRecentLocation(recentLocations);
    }

    _ipType = location.ipType;
  }

  /// Determines if a location should be skipped when adding to recent locations.
  /// A location is skipped if it is not part of the currently available locations based on its IP type.
  bool _shouldSkipLocation(VPNLocation location) => switch (location.ipType) {
        IPType.datacenter => !_listContainsLocation(_dcLocationsFuture.value, location),
        IPType.residential => !_listContainsLocation(_residentialLocationsFuture.value, location),
        IPType.closest => true,
      };

  /// Checks if a given location exists in the provided list of locations.
  /// Returns false if the list is null or the location is not found.
  bool _listContainsLocation(VPNLocations? list, VPNLocation location) {
    if (list == null) {
      return false;
    }
    return list.allLocationsFlattened.any((it) => it == location);
  }

  /// Sets the search keyword for filtering locations, applying a debounce to avoid excessive updates.
  @action
  void setLocationKeyword(String text, [Duration duration = const Duration(milliseconds: 500)]) {
    _debouncer.debounce(
      () async {
        _searchKeyword = text.toLowerCase().trim();
        _analyticsStore
          ..setSearchEvent(_searchKeyword)
          ..logEvent(AnalyticsEvent.search);
      },
      duration,
    );
  }

  /// Sets the current IP type (datacenter or residential) and persists the preference.
  @action
  Future<void> setIPType(IPType type) async {
    _ipType = type;
    await _prefs.setIPType(type);
  }

  /// Disposes of resources such as debouncers and stream subscriptions to prevent memory leaks.
  FutureOr<void> dispose() async {
    _debouncer.dispose();
    await _autoRefreshSubscription?.cancel();

    // Cancel all stream subscriptions
    await Future.wait(_subs.map((it) => it.cancel()));
  }

  /// Clears the recent locations list from the local database.
  @action
  Future<void> resetRecentLocations() async {
    await _localDB.setRecentLocation([]);
  }

  /// Clears all stored locations (both datacenter and residential) from the local database.
  /// This is primarily used for development purposes to reset cached data.
  @action
  Future<void> resetStoredLocations() async {
    await Future.wait([
      _localDB.setLocations(VPNLocations(), type: IPType.residential),
      _localDB.setLocations(VPNLocations(), type: IPType.datacenter),
    ]);
  }
}

/// Maps a list of country codes to `VPNLocation` objects with localized names.
/// Each location is assigned the specified IP type (defaulting to residential if not provided).
/// This is useful for creating location entries for countries without specific city data.
/// The country codes should be in ISO 3166-1 alpha-2 format.
List<VPNLocation> countriesToLocations(Iterable<String> countries, IPType? ipType) {
  final locales = kSupportedLocales;

  return countries
      .map(
        (code) => VPNLocation(
          id: code,
          translations: {
            for (final locale in locales) locale.languageCode.toLowerCase(): code.tr(),
          },
          ipType: ipType ?? IPType.residential,
          countryCode: code,
        ),
      )
      .toList();
}

class RegionWithLatency {
  const RegionWithLatency(this.region, this.latency);

  final ConnectionRegion region;
  final Duration latency;
}

List<VPNLocation> _mapLocations(
  List<ConnectionLocation> response, [
  IPType ipType = IPType.residential,
]) =>
    response.map((it) => _mapCountry(it, ipType)).toList();

VPNLocation _mapCountry(ConnectionLocation response, [IPType ipType = IPType.residential]) =>
    VPNLocation(
      id: response.country,
      ipType: ipType,
      translations: response.translations,
      nodeCount: response.total.toInt(),
      children: response.cities.map((it) => _mapCity(it, response.country, ipType)).toList(),
      countryCode: response.country,
    );

VPNLocation _mapCity(
  ConnectionLocationCity response,
  String country,
  IPType ipType,
) {
  LatLng? coordinates;
  if (response.latitude != null && response.longitude != null) {
    coordinates = LatLng(response.latitude!.toDouble(), response.longitude!.toDouble());
  }
  return VPNLocation(
    id: response.city,
    ipType: ipType,
    translations: response.translations,
    nodeCount: response.total.toInt(),
    countryCode: country,
    coordinates: coordinates,
  );
}
