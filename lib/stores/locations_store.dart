import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/recent_location.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore() {
    fetchRecentLocations();
    fetchTopLocations();
  }

  @observable
  bool showAllLocations = false;

  List<Location> topLocations = [];

  List<RecentLocation> recentLocations = [];

  List<Location> allLocations = [];

  Timer? _debounce;

  @observable
  ObservableFuture<List<Location>> fetchTopLocationsFuture = emptyLocations;

  @observable
  ObservableFuture<List<RecentLocation>> fetchRecentLocationsFeature = emptyRecentLocations;

  @observable
  ObservableFuture<List<Location>> fetchAllLocationsFuture = emptyLocations;

  @observable
  String searchKeyword = '';

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
      fetchRecentLocationsFeature != emptyRecentLocations &&
      fetchRecentLocationsFeature.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Location>> emptyLocations = ObservableFuture.value([]);
  static ObservableFuture<List<RecentLocation>> emptyRecentLocations = ObservableFuture.value([]);

  @action
  Future<List<Location>> fetchTopLocations() async {
    topLocations = [];
    final future = Future.delayed(const Duration(seconds: 3), () {
      return searchKeyword.isNotEmpty
          ? locationsMock
              .where((element) => element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
              .toList()
          : locationsMock;
    });
    fetchTopLocationsFuture = ObservableFuture(future);

    return topLocations = await future;
  }

  @action
  Future<List<Location>> fetchAllLocations() async {
    allLocations = [];
    final future = Future.delayed(const Duration(seconds: 3), () {
      return searchKeyword.isNotEmpty
          ? locationsMock
              .where((element) => element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
              .toList()
          : locationsMock;
    });
    fetchAllLocationsFuture = ObservableFuture(future);

    return allLocations = await future;
  }

  @action
  Future<List<RecentLocation>> fetchRecentLocations() async {
    recentLocations = [];
    final future = Future.delayed(const Duration(seconds: 3), () {
      return searchKeyword.isNotEmpty
          ? recentLocationsMock
              .where((element) => element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
              .toList()
          : recentLocationsMock;
    });
    fetchRecentLocationsFeature = ObservableFuture(future);

    return recentLocations = await future;
  }

  @action
  void toggleShowAllLocations() {
    showAllLocations = !showAllLocations;
    if (showAllLocations) {
      fetchAllLocations();
    } else {
      fetchTopLocations();
      fetchRecentLocations();
    }
  }

  @action
  void setLocationKeyword(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchTopLocationsFuture = emptyLocations;
      fetchRecentLocationsFeature = emptyRecentLocations;
      fetchAllLocationsFuture = emptyLocations;
      searchKeyword = text;
      fetchRecentLocations();
      fetchTopLocations();
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
