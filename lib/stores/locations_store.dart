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
    fetchLocations();
  }

  List<Location> locations = [];

  List<RecentLocation> recentLocations = [];

  Timer? _debounce;

  @observable
  ObservableFuture<List<Location>> fetchLocationsFuture = emptyResponse;

  @observable
  ObservableFuture<List<RecentLocation>> fetchRecentLocationsFeature = emptyRecentResponse;

  @observable
  String searchKeyword = '';

  @computed
  bool get hasLocationsResults =>
      fetchLocationsFuture != emptyResponse &&
      fetchLocationsFuture.status == FutureStatus.fulfilled;

  @computed
  bool get hasRecentLocationsResults =>
      fetchRecentLocationsFeature != emptyRecentResponse &&
      fetchRecentLocationsFeature.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Location>> emptyResponse = ObservableFuture.value([]);
  static ObservableFuture<List<RecentLocation>> emptyRecentResponse = ObservableFuture.value([]);

  @action
  Future<List<Location>> fetchLocations() async {
    locations = [];
    final future = Future.delayed(const Duration(seconds: 3), () {
      return searchKeyword.isNotEmpty
          ? locationsMock
              .where((element) => element.name.toLowerCase().contains(searchKeyword.toLowerCase()))
              .toList()
          : locationsMock;
    });
    fetchLocationsFuture = ObservableFuture(future);

    return locations = await future;
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
  void setLocationKeyword(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchLocationsFuture = emptyResponse;
      fetchRecentLocationsFeature = emptyRecentResponse;
      searchKeyword = text;
      fetchRecentLocations();
      fetchLocations();
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
