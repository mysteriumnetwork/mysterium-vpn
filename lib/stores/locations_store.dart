import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore({
    required ApiService apiService,
    required AnalyticsStore analyticsStore,
    required AuthStore authStore,
  })  : _apiService = apiService,
        _analyticsStore = analyticsStore,
        _authStore = authStore {
    autorun((_) async {
      if (_authStore.authData != null) {
        fetchVPNLocations().whenComplete(fetchRecentLocations);
      }
    });
  }

  final ApiService _apiService;
  final AnalyticsStore _analyticsStore;
  final AuthStore _authStore;

  ObservableList<String> recentLocations = ObservableList();

  VPNLocations vpnLocations = VPNLocations(allLocations: [], topLocations: []);

  Timer? _debounce;

  @observable
  ObservableFuture<VPNLocations> fetchVPNLocationsFuture = emptyLocations;

  @observable
  String searchKeyword = '';

  @computed
  FutureStatus get vpnLocationsFutureStatus => fetchVPNLocationsFuture.status;

  static ObservableFuture<VPNLocations> emptyLocations =
      ObservableFuture.value(VPNLocations(allLocations: [], topLocations: []));

  @action
  Future<VPNLocations> fetchVPNLocations() async {
    fetchVPNLocationsFuture =
        ObservableFuture(_apiService.fetchVPNLocations(keyword: searchKeyword));
    final res = await fetchVPNLocationsFuture;
    return vpnLocations = res;
  }

  @action
  void fetchRecentLocations() {
    recentLocations
      ..clear()
      ..addAll(
        _apiService.getRecentLocations(keyword: searchKeyword)
          ..removeWhere((element) {
            print(element);
            return !vpnLocations.allLocations.contains(element) &&
                !vpnLocations.topLocations.contains(element);
          }),
      );
  }

  @action
  void addRecentLocation(String location) {
    _apiService.addRecentLocation(location);
    fetchRecentLocations();
  }

  @action
  void setLocationKeyword(String text, [int duration = 500]) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(Duration(milliseconds: duration), () {
      searchKeyword = text.toLowerCase().trim();
      fetchVPNLocations().whenComplete(fetchRecentLocations);
      _analyticsStore.setSearchEvent(searchKeyword);
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
