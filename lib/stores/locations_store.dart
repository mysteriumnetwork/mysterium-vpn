import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore({
    required ApiService apiService,
    required AuthSessionStore authSessionStore,
    required AnalyticsStore analyticsStore,
    required LocaleStore localeStore,
  })  : _apiService = apiService,
        _authSessionStore = authSessionStore,
        _analyticsStore = analyticsStore {
    fetchVPNLocations();
    reaction((_) => _authSessionStore.user, (_) async {
      if (_authSessionStore.user != null) {
        await fetchVPNLocationsFuture.whenComplete(fetchRecentLocations);
      }
    });
    reaction((_) => localeStore.currentLocale, (locale) {
      if (searchKeyword.isNotEmpty) {
        setLocationKeyword('');
      }
    });
  }

  final ApiService _apiService;
  final AuthSessionStore _authSessionStore;
  final AnalyticsStore _analyticsStore;

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
  Future<void> fetchRecentLocations() async {
    if (_authSessionStore.user == null) {
      throw AuthenticationRequiredException();
    }

    final locations =
        await _apiService.getRecentLocations(_authSessionStore.user!, keyword: searchKeyword);

    recentLocations
      ..clear()
      ..addAll(
        locations
          ..removeWhere(
            (element) =>
                !vpnLocations.allLocations.contains(element) &&
                !vpnLocations.topLocations.contains(element),
          ),
      );
  }

  @action
  Future<void> addRecentLocation(String location) async {
    await _apiService.addRecentLocation(location);
    await fetchRecentLocations();
  }

  @action
  void setLocationKeyword(String text, [int duration = 500]) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(Duration(milliseconds: duration), () {
      searchKeyword = text.toLowerCase().trim();
      fetchVPNLocations().whenComplete(fetchRecentLocations);
      _analyticsStore
        ..setSearchEvent(searchKeyword)
        ..logEvent(AnalyticsEvent.search);
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
