import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/api.dart';
import 'package:mysterium_vpn/common/extensions/stream_extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
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

    _detectClosestRegion();
    _autoRefresh();
  }

  final Connection _apiConnection;
  final FilterService _filterService;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final SharedPreferenceService _prefs;
  final LocalDBService _localDB;
  final Talker _logger;

  final Debouncer _debouncer = Debouncer();
  StreamSubscription<dynamic>? _autoRefreshSubscription;

  @readonly
  late ObservableStream<VPNLocations> _dcLocationsStream = ObservableStream(
    _watch(IPType.datacenter).distinct().doOnListen(() => refresh(IPType.datacenter)),
    initialValue: _localDB.getLocations(IPType.datacenter),
  );

  @readonly
  late ObservableStream<VPNLocations> _residentialLocationsStream = ObservableStream(
    _watch(IPType.residential).distinct().doOnListen(() => refresh(IPType.residential)),
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
      return _filterService.filterLocations(
        value,
        keyword: _searchKeyword,
        shouldSortList: false,
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

    return const VPNLocation(ipType: IPType.closest);
  }

  Stream<VPNLocations> _watch(IPType ipType) async* {
    final cached = _localDB.getLocations(_ipType);
    if (cached != null) {
      yield cached;
    }

    yield* _localDB.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  @action
  Future<void> _detectClosestRegion() async {
    const servers = [
      ['5.223.54.236', '56666'],
      ['5.78.41.116', '56666'],
      ['49.13.201.36', '56666'],
      ['195.201.19.125', '56666'],
      ['5.223.45.14', '56666'],
      ['128.140.102.112', '56666'],
      ['5.223.48.63', '56666'],
      ['5.223.43.40', '56666'],
      ['23.88.100.197', '56666'],
      ['5.161.225.73', '56666'],
      ['5.223.46.96', '56666'],
      ['78.47.113.108', '56666'],
      ['5.161.94.120', '56666'],
      ['5.161.113.101', '56666'],
      ['88.99.85.196', '56666'],
      ['178.156.151.5', '56666'],
    ];

    servers.forEach((server) async {
      final ping = Ping(server[0]);
      ping.latencyMedian().then((latency) {
        print('==PING: ${server[0]}, ${latency.inMilliseconds}ms');
      });
    });
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
      final data = (await _apiConnection.connectionConfig(
        ipType: switch (ipType) {
          IPType.datacenter => 'hosting',
          IPType.residential => 'residential',
          _ => null,
        },
      ))
          .data;
      if (data == null) {
        throw Exception('No data found');
      }
      final topLocations = data.topCountries
          .map(
            (code) => VPNLocation(
              code: code,
              ipType: ipType ?? IPType.residential,
            ),
          )
          .toList();

      final locations = data.countries
          .where((it) => !data.topCountries.contains(it))
          .map(
            (code) => VPNLocation(
              code: code,
              ipType: ipType ?? IPType.residential,
            ),
          )
          .toList();

      await _localDB.setLocations(
        VPNLocations(
          topLocations: topLocations,
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
    if (recentLocations.contains(location)) {
      recentLocations.remove(location);
    }
    recentLocations.insert(0, location);
    if (recentLocations.length > 5) {
      recentLocations.removeLast();
    }
    await _localDB.setRecentLocation(recentLocations);
    _ipType = location.ipType;
    _recentLocationsFuture = _recentLocationsFuture.replace(_localDB.getRecentLocations());
    await _recentLocationsFuture;
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
