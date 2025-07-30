import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/common/extensions/stream_extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
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

abstract class _LocationsStore with Store {
  _LocationsStore(
    this._apiConnection,
    this._filterService,
    this._analyticsStore,
    this._remoteConfigStore,
    this._prefs,
    this._localDB,
    this._logger,
    LocaleStore localeStore,
    this._ping,
  ) {
    /// mobx stream won't initialize if not used within ReactiveContext scope, so this is done to
    /// preload locations as soon as store is created
    autorun((_) {
      _dcLocationsStream.value;
      _residentialLocationsStream.value;
    });

    reaction((_) => localeStore.currentLocale, (locale) {
      if (_searchKeyword.isNotEmpty) {
        setLocationKeyword('');
      }
    });

    _autoRefresh();
  }

  final Connection _apiConnection;
  final FilterService _filterService;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
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
    _localDB.getRecentLocations(),
  );

  @readonly
  String _searchKeyword = '';

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  @observable
  VPNLocation? selectedLocation;

  @computed
  List<VPNLocation> get recentLocations {
    final value = _recentLocationsFuture.value;
    if (value != null) {
      return _filterService.filterRecentLocations(
        value,
        availableLocations: {
          ..._dcLocationsStream.value?.allLocations ?? [],
          ..._residentialLocationsStream.value?.allLocations ?? [],
        },
        keyword: _searchKeyword,
      );
    }
    return [];
  }

  @computed
  List<VPNLocation> get locations {
    final value = locationsStream.value?.locations;
    if (value != null) {
      return _filterService.filterLocations(value, keyword: _searchKeyword);
    }
    return [];
  }

  @computed
  List<VPNLocation> get topLocations {
    final value = locationsStream.value?.topLocations;
    if (value != null) {
      return _filterService.filterLocations(value, keyword: _searchKeyword);
    }
    return [];
  }

  VPNLocation randomLocation([IPType? type]) {
    var recents = recentLocations;
    if (type != null) {
      recents = recentLocations.where((location) => location.ipType == type).toList();
    }
    if (recents.isNotEmpty) {
      return recents.first;
    }

    return const VPNLocation(
      id: '',
      translations: {},
      ipType: IPType.closest,
      countryCode: '',
    );
  }

  Future<VPNLocation?> closestLocation([IPType? type]) async {
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

    final closestRegion = await _detectClosestRegion(connectionConfigRegions.regions);

    final closestLocations = countriesToLocations(closestRegion.topCountries, type);
    if (closestLocations.isEmpty) {
      return null;
    }

    final r = Random();
    return closestLocations[r.nextInt(closestLocations.length)];
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
  List<Locale> locales;
  try {
    locales = EasyLocalization.of(rootContext)!.supportedLocales;
  } catch (e) {
    // If EasyLocalization is not initialized, fallback to default locales
    locales = kSupportedLocales;
  }

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
) =>
    VPNLocation(
      id: response.city,
      ipType: ipType,
      translations: response.translations,
      nodeCount: response.total.toInt(),
      countryCode: country,
    );
