import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore({required ApiService apiService}) : _apiService = apiService {
    fetchRecentLocations();
    fetchTopLocations();
    fetchAllLocations();
  }

  final ApiService _apiService;

  @observable
  bool showAllLocations = false;

  List<Location> topLocations = [];

  List<Location> recentLocations = [];

  List<Location> allLocations = [];

  Timer? _debounce;

  @observable
  ObservableFuture<List<Location>> fetchTopLocationsFuture = emptyLocations;

  @observable
  ObservableFuture<List<Location>> fetchRecentLocationsFeature = emptyRecentLocations;

  @observable
  ObservableFuture<List<Location>> fetchAllLocationsFuture = emptyLocations;

  @observable
  String searchTopKeyword = '';
  @observable
  String searchAllKeyword = '';

  @computed
  bool get hasTopLocationsResults =>
      fetchTopLocationsFuture != emptyLocations &&
      fetchTopLocationsFuture.status == FutureStatus.fulfilled;

  @computed
  bool get hasAllLocationsResults =>
      fetchAllLocationsFuture != emptyLocations &&
      fetchAllLocationsFuture.status == FutureStatus.fulfilled;

  @computed
  bool get hasRecentLocationsResults =>
      fetchRecentLocationsFeature.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Location>> emptyLocations = ObservableFuture.value([]);
  static ObservableFuture<List<Location>> emptyRecentLocations = ObservableFuture.value([]);

  @action
  Future<List<Location>> fetchTopLocations() async {
    topLocations = [];

    fetchTopLocationsFuture = ObservableFuture(
      _apiService.fetchTopLocations(
        keyword: searchTopKeyword,
      ),
    );

    return topLocations = await fetchTopLocationsFuture;
  }

  @action
  Future<List<Location>> fetchAllLocations() async {
    allLocations = [];

    fetchAllLocationsFuture =
        ObservableFuture(_apiService.fetchAllLocations(keyword: searchAllKeyword));

    return allLocations = await fetchAllLocationsFuture;
  }

  @action
  Future<List<Location>> fetchRecentLocations() async {
    recentLocations = [];

    fetchRecentLocationsFeature =
        ObservableFuture(_apiService.getRecentLocations(keyword: searchTopKeyword));

    return recentLocations = await fetchRecentLocationsFeature;
  }

  @action
  void toggleShowAllLocations() {
    showAllLocations = !showAllLocations;
  }

  @action
  void setLocationKeyword(String text, [int duration = 500]) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(Duration(milliseconds: duration), () {
      if (showAllLocations) {
        searchAllKeyword = text.trim();
        fetchAllLocations();
        return;
      }
      searchTopKeyword = text.trim();
      fetchRecentLocations();
      fetchTopLocations();
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
