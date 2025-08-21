import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/common/extensions/stream_extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
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

abstract class _LocationsStore with Store {
  _LocationsStore(
    this._apiConnection,
    this._filterService,
    this._analyticsStore,
    this._remoteConfigStore,
    this._authSessionStore,
    this._prefs,
    this._localDB,
    this._logger,
    this._localeStore,
    this._ping,
  ) {
    /// mobx stream won't initialize if not used within ReactiveContext scope, so this is done to
    /// preload locations as soon as store is created
    autorun((_) {
      _dcLocationsStream.value;
      _residentialLocationsStream.value;
    });

    reaction((_) => _localeStore.currentLocale, (locale) {
      if (_searchKeyword.isNotEmpty) {
        setLocationKeyword('');
      }
    });

    reaction((_) => _authSessionStore.user?.userId, (id) {
      _recentLocationsFuture = _recentLocationsFuture.replace(
        _fetchRecentLocations(),
      );
    });

    _autoRefresh();
  }

  final Connection _apiConnection;
  final FilterService _filterService;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final LocaleStore _localeStore;
  final AuthSessionStore _authSessionStore;
  final SharedPreferenceService _prefs;
  final LocalDBService _localDB;
  final Talker _logger;
  final Ping? _ping;

  final Debouncer _debouncer = Debouncer();
  StreamSubscription<dynamic>? _autoRefreshSubscription;

  @readonly
  late ObservableStream<VPNLocations> _dcLocationsStream = ObservableStream(
    _watch(IPType.datacenter).distinct().doOnListen(
          () => refresh(IPType.datacenter),
          onError: _logger.handle,
        ),
    initialValue: _localDB.getLocations(IPType.datacenter),
  );

  @readonly
  late ObservableStream<VPNLocations> _residentialLocationsStream = ObservableStream(
    _watch(IPType.residential).distinct().doOnListen(
          () => refresh(IPType.residential),
          onError: _logger.handle,
        ),
    initialValue: _localDB.getLocations(IPType.residential),
  );

  @computed
  ObservableStream<VPNLocations> get locationsStream => switch (_ipType) {
        IPType.datacenter => _dcLocationsStream,
        _ => _residentialLocationsStream,
      };

  @readonly
  late ObservableFuture<List<VPNLocation>> _recentLocationsFuture = ObservableFuture(
    _fetchRecentLocations(),
  );

  @readonly
  String _searchKeyword = '';

  @computed
  Set<String> get availableCountries => {
        ...?_dcLocationsStream.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
        ...?_residentialLocationsStream.value?.allLocations
            .where((it) => it.isCountry)
            .map((it) => it.countryCode),
      };

  @action
  Future<List<VPNLocation>> _fetchRecentLocations() async {
    final hasUser = (await _authSessionStore.userFuture) != null;
    if (!hasUser) {
      return [];
    }

    final locations = await _localDB.getRecentLocations();
    final availableLocations = {
      ...?_dcLocationsStream.value?.allLocationsFlattened,
      ...?_residentialLocationsStream.value?.allLocationsFlattened,
    };

    return _filterService.filterRecentLocations(
      locations,
      availableLocations: availableLocations,
      keyword: _searchKeyword,
      locale: _localeStore.currentLocale.languageCode.toLowerCase(),
    );
  }

  @computed
  bool get _locationsNotEmpty =>
      (_residentialLocationsStream.value?.locations.isNotEmpty ?? false) ||
      (_dcLocationsStream.value?.locations.isNotEmpty ?? false);

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  @observable
  VPNLocation? selectedLocation;

  @computed
  List<VPNLocation> get recentLocations => _recentLocationsFuture.value ?? [];

  @computed
  List<VPNLocation> get locations {
    final value = locationsStream.value?.locations;
    if (value != null) {
      return _filterService.filterLocations(
        value,
        keyword: _searchKeyword,
        locale: _localeStore.currentLocale.languageCode.toLowerCase(),
      );
    }
    return [];
  }

  @computed
  List<VPNLocation> get topLocations {
    final value = locationsStream.value?.topLocations;
    if (value != null) {
      return _filterService.filterLocations(
        value,
        keyword: _searchKeyword,
        locale: _localeStore.currentLocale.languageCode.toLowerCase(),
      );
    }
    return [];
  }

  @computed
  VPNLocation? get randomLocation {
    if (_recentLocationsFuture.status == FutureStatus.pending) {
      return null;
    }
    if (recentLocations.isNotEmpty) {
      return recentLocations.first;
    }

    if (_locationsNotEmpty) {
      return const VPNLocation(
        id: '',
        translations: {},
        ipType: IPType.closest,
        countryCode: '',
      );
    }
    return null;
  }

  @action
  VPNLocation findLocation(
    String id, {
    String? countryCode,
    IPType ipType = IPType.datacenter,
  }) {
    final locations = switch (ipType) {
          IPType.datacenter => _dcLocationsStream.value?.allLocationsFlattened,
          IPType.residential => _residentialLocationsStream.value?.allLocationsFlattened,
          _ => null,
        } ??
        const <VPNLocation>[];

    var match = locations.firstWhereOrNull((it) => it.id == id);

    // if no city is in our list, we try to find a country
    match ??= locations.firstWhereOrNull(
      (it) => it.isCountry && it.countryCode == (countryCode ?? id),
    );

    match ??= VPNLocation(
      id: id,
      ipType: ipType,
      translations: const {},
      countryCode: countryCode ?? id,
    );

    return match;
  }

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

  Stream<VPNLocations> _watch(IPType ipType) async* {
    final cached = _localDB.getLocations(_ipType);
    if (cached != null) {
      yield cached;
    }

    yield* _localDB.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  Future<ConnectionRegion> _detectClosestRegion(List<ConnectionRegion> regions) async {
    // Ensures all pings complete before finding the lowest latency
    final regionsWithLatencies = await Future.wait(
      regions.map((region) async {
        final ping = _ping ?? Ping(region.host, 80);
        return RegionWithLatency(region, await ping.latencyMedian());
      }),
    );

    // Find region with lowest latency
    final region = regionsWithLatencies.reduce(
      (a, b) => a.latency < b.latency ? a : b,
    );

    return region.region;
  }

  Future<void> _autoRefresh() async {
    await _remoteConfigStore.configFuture;
    _autoRefreshSubscription = Stream.periodic(_remoteConfigStore.locationsRefreshInterval).listen(
      (_) => refresh(),
    );
  }

  @action
  Future<void> refresh([IPType? ipType]) async {
    ipType ??= _ipType;

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

      final locations = _mapLocations(connectionConfig, ipType);

      await _localDB.setLocations(
        VPNLocations(
          topLocations: [],
          locations: locations,
        ),
        type: ipType,
      );
    } on ApiException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

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
      _recentLocationsFuture = _recentLocationsFuture.replace(_localDB.getRecentLocations());
      await _recentLocationsFuture;
    }

    _ipType = location.ipType;
  }

  bool _shouldSkipLocation(VPNLocation location) => switch (location.ipType) {
        IPType.datacenter => !_listContainsLocation(_dcLocationsStream.value, location),
        IPType.residential => !_listContainsLocation(_residentialLocationsStream.value, location),
        IPType.closest => true,
      };

  bool _listContainsLocation(VPNLocations? list, VPNLocation location) {
    if (list == null) {
      return false;
    }
    return list.allLocationsFlattened.any((it) => it == location);
  }

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

  @action
  Future<void> setIPType(IPType type) async {
    _ipType = type;
    await _prefs.setIPType(type);
  }

  FutureOr<void> dispose() async {
    _debouncer.dispose();
    await _autoRefreshSubscription?.cancel();
    await _dcLocationsStream.close();
    await _residentialLocationsStream.close();
  }

  @action
  Future<void> resetRecentLocations() async {
    await _localDB.setRecentLocation([]);
    _recentLocationsFuture = _recentLocationsFuture.replace(_localDB.getRecentLocations());
    await _recentLocationsFuture;
  }

  @action
  Future<void> resetStoredLocations() async {
    await Future.wait([
      _localDB.setLocations(VPNLocations(), type: IPType.residential),
      _localDB.setLocations(VPNLocations(), type: IPType.datacenter),
    ]);
  }
}

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
