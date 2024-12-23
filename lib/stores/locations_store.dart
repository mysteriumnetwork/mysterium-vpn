import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore(
    this._apiService,
    this._analyticsStore,
    LocaleStore localeStore,
  ) {
    fetchVPNLocations();
    reaction((_) => localeStore.currentLocale, (locale) {
      if (searchKeyword.isNotEmpty) {
        setLocationKeyword('');
      }
    });
  }

  final ApiService _apiService;
  final AnalyticsStore _analyticsStore;
  final Debouncer _debouncer = Debouncer();

  @readonly
  ObservableFuture<VPNLocations> _vpnLocationsFuture = ObservableFuture.value(const VPNLocations());

  @observable
  String searchKeyword = '';

  @readonly
  List<VPNLocation> _recentLocations = [];

  @computed
  List<VPNLocation> get allLocations => _vpnLocationsFuture.value?.allLocations ?? [];

  @computed
  List<VPNLocation> get topLocations => _vpnLocationsFuture.value?.topLocations ?? [];

  @computed
  List<VPNLocation> get dcLocations => _vpnLocationsFuture.value?.dcLocations ?? [];

  VPNLocation? randomLocation([IPType? type]) {
    final residentialLocations = topLocations.isEmpty ? allLocations : topLocations;
    final locations = [
      if (type == null || type == IPType.residential) ...residentialLocations,
      if (type == null || type == IPType.datacenter) ...dcLocations,
    ];

    if (locations.isEmpty) {
      return null;
    }

    var recent = _recentLocations;
    if (type != null) {
      recent = _recentLocations.where((location) => location.ipType == type).toList();
    }
    if (recent.isNotEmpty) {
      return recent.first;
    }

    return locations.randomItem();
  }

  @action
  Future<void> fetchVPNLocations() async {
    _vpnLocationsFuture = ObservableFuture(
      _apiService.fetchVPNLocations(keyword: searchKeyword),
    );
    await _vpnLocationsFuture;
    await fetchRecentLocations();
  }

  @action
  Future<void> fetchRecentLocations() async {
    final vpnLocations = await _vpnLocationsFuture;
    final locations = await _apiService.getRecentLocations(keyword: searchKeyword);
    _recentLocations = locations
        .where(
          (code) =>
              vpnLocations.allLocations.contains(code) ||
              vpnLocations.topLocations.contains(code) ||
              vpnLocations.dcLocations.contains(code),
        )
        .toList();
  }

  @action
  Future<void> addRecentLocation(VPNLocation location) async {
    await _apiService.addRecentLocation(location);
    _recentLocations = {location, ..._recentLocations}.toList();
    await fetchRecentLocations();
  }

  @action
  void setLocationKeyword(String text, [Duration duration = const Duration(milliseconds: 500)]) {
    _debouncer.debounce(
      () async {
        searchKeyword = text.toLowerCase().trim();
        _analyticsStore
          ..setSearchEvent(searchKeyword)
          ..logEvent(AnalyticsEvent.search);
        await fetchVPNLocations();
      },
      duration,
    );
  }

  void dispose() => _debouncer.dispose();
}
