import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/models/location.dart';

part 'locations_store.g.dart';

// ignore: library_private_types_in_public_api
class LocationsStore = _LocationsStore with _$LocationsStore;

abstract class _LocationsStore with Store {
  _LocationsStore() {
    fetchRecentLocations();
    fetchTopLocations();
    fetchAllLocations();
  }

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
      fetchRecentLocationsFeature != emptyRecentLocations &&
      fetchRecentLocationsFeature.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Location>> emptyLocations = ObservableFuture.value([]);
  static ObservableFuture<List<Location>> emptyRecentLocations = ObservableFuture.value([]);

  @action
  Future<List<Location>> fetchTopLocations() async {
    topLocations = [];
    final future = Future.delayed(
      const Duration(seconds: 3),
      () => searchTopKeyword.isNotEmpty
          ? topLocationsMock
              .where(
                (element) =>
                    element.countryName.toLowerCase().contains(searchTopKeyword.toLowerCase()),
              )
              .toList()
          : topLocationsMock,
    );
    fetchTopLocationsFuture = ObservableFuture(future);

    return topLocations = await future;
  }

  @action
  Future<List<Location>> fetchAllLocations() async {
    allLocations = [];
    final future = Future.delayed(
      const Duration(seconds: 3),
      () => searchAllKeyword.isNotEmpty
          ? allLocationsMock
              .where(
                (element) =>
                    element.countryName.toLowerCase().contains(searchAllKeyword.toLowerCase()),
              )
              .toList()
          : allLocationsMock,
    );
    fetchAllLocationsFuture = ObservableFuture(future);

    return allLocations = await future;
  }

  @action
  Future<List<Location>> fetchRecentLocations() async {
    recentLocations = [];
    final future = Future.delayed(
      const Duration(seconds: 3),
      () => searchTopKeyword.isNotEmpty
          ? recentLocationsMock
              .where(
                (element) =>
                    element.countryName.toLowerCase().contains(searchTopKeyword.toLowerCase()),
              )
              .toList()
          : recentLocationsMock,
    );
    fetchRecentLocationsFeature = ObservableFuture(future);

    return recentLocations = await future;
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
