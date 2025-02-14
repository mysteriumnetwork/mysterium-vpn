import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
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
    LocaleStore localeStore,
  ) {
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

  final Debouncer _debouncer = Debouncer();
  StreamSubscription<dynamic>? _autoRefreshSubscription;

  @readonly
  late ObservableFuture<VPNLocations> _dcLocationsFuture = ObservableFuture(
    _apiService.fetchVPNLocations(IPType.datacenter),
  );

  @readonly
  late ObservableFuture<VPNLocations> _residentialLocationsFuture = ObservableFuture(
    _apiService.fetchVPNLocations(IPType.residential),
  );

  @computed
  ObservableFuture<VPNLocations> get locationsFuture => switch (_ipType) {
        IPType.datacenter => _dcLocationsFuture,
        IPType.residential => _residentialLocationsFuture,
      };

  @readonly
  late ObservableFuture<List<VPNLocation>> _recentLocationsFuture = ObservableFuture(
    _apiService.getRecentLocations(),
  );

  @readonly
  String _searchKeyword = '';

  @readonly
  late IPType _ipType = _prefs.getIPType() ?? IPType.residential;

  @computed
  List<VPNLocation> get recentLocations {
    final value = _recentLocationsFuture.value;
    if (value != null) {
      return _filterService.filterLocations(value, keyword: _searchKeyword);
    }
    return [];
  }

  @computed
  List<VPNLocation> get locations {
    final value = locationsFuture.value?.locations;
    if (value != null) {
      return _filterService.filterLocations(value, keyword: _searchKeyword);
    }
    return [];
  }

  @computed
  List<VPNLocation> get topLocations {
    final value = locationsFuture.value?.topLocations;
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
      return recents.randomItem();
    }

    final future = switch (type) {
      IPType.datacenter => _dcLocationsFuture,
      _ => _residentialLocationsFuture,
    };

    final locations = [...?future.value?.locations, ...?future.value?.topLocations];
    if (locations.isEmpty) {
      return null;
    }

    return locations.randomItem();
  }

  Future<void> _autoRefresh() async {
    await _remoteConfigStore.configFuture;
    _autoRefreshSubscription = Stream.periodic(_remoteConfigStore.locationsRefreshInterval).listen(
      (_) => refresh(),
    );
  }

  @action
  Future<void> refresh() async {
    switch (_ipType) {
      case IPType.datacenter:
        _dcLocationsFuture = _dcLocationsFuture.replace(
          _apiService.fetchVPNLocations(IPType.datacenter),
        );
        await _dcLocationsFuture;
        break;
      case IPType.residential:
        _residentialLocationsFuture = _residentialLocationsFuture.replace(
          _apiService.fetchVPNLocations(IPType.residential),
        );
        await _residentialLocationsFuture;
        break;
    }
  }

  @action
  Future<void> addRecentLocation(VPNLocation location) async {
    await _apiService.addRecentLocation(location);
    _ipType = location.ipType;
    _recentLocationsFuture = _recentLocationsFuture.replace(_apiService.getRecentLocations());
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
}
