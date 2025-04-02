import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/stream_extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore(
    this._apiService,
    this._filterService,
    this._analyticsStore,
    this._remoteConfigStore,
    this._prefs,
    this._localDB,
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

    _autoRefresh();
  }

  final ApiService _apiService;
  final FilterService _filterService;
  final AnalyticsStore _analyticsStore;
  final RemoteConfigStore _remoteConfigStore;
  final SharedPreferenceService _prefs;
  final LocalDBService _localDB;

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

  VPNLocation? randomLocation([IPType? type]) {
    var recents = recentLocations;
    if (type != null) {
      recents = recentLocations.where((location) => location.ipType == type).toList();
    }
    if (recents.isNotEmpty) {
      return recents.first;
    }

    final value = switch (type) {
      IPType.datacenter => _dcLocationsStream.value,
      _ => _residentialLocationsStream.value,
    };

    final locations = [...?value?.locations, ...?value?.topLocations];
    if (locations.isEmpty) {
      return null;
    }

    return null;
  }

  Stream<VPNLocations> _watch(IPType ipType) async* {
    final cached = _localDB.getLocations(_ipType);
    if (cached != null) {
      yield cached;
    }

    yield* _localDB.watchLocations(ipType).where((it) => it != null).map((it) => it!);
  }

  Future<void> _autoRefresh() async {
    await _remoteConfigStore.configFuture;
    _autoRefreshSubscription = Stream.periodic(_remoteConfigStore.locationsRefreshInterval).listen(
      (_) => refresh(),
    );
  }

  @action
  Future<VPNLocations> refresh([IPType? ipType]) async {
    ipType ??= _ipType;

    final locations = await _apiService.fetchVPNLocations(ipType);
    await _localDB.setLocations(locations, type: ipType);

    return locations;
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
