import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';

part 'recent_locations_store.g.dart';

// ignore: library_private_types_in_public_api
class RecentLocationsStore = _RecentLocationsStore with _$RecentLocationsStore;

abstract class _RecentLocationsStore with Store {
  _RecentLocationsStore(
    this._db,
    this._filter,
    this._query,
    this._config,
    this._locations,
    this._locale,
  ) {
    _dbChangesSubscription = _db.watchRecentLocations().listen((locations) {
      _future = _future.replaceOrReset(Future.value(locations));
    });
  }

  final LocalDBService _db;
  final FilterService _filter;

  final LocationsQueryStore _query;
  final RemoteConfigStore _config;
  final LocationsStore _locations;
  final LocaleStore _locale;

  late final StreamSubscription<List<VPNLocation>> _dbChangesSubscription;

  @readonly
  late ObservableFuture<List<VPNLocation>> _future = ObservableFuture(_db.getRecentLocations());

  @computed
  List<VPNLocation> get value {
    var data = _future.value ?? const <VPNLocation>[];
    if (data.isEmpty) {
      return const <VPNLocation>[];
    }

    data = data.intersect({
      ...?_locations.dcLocationsFuture.value?.allLocationsFlattened,
      ...?_locations.residentialLocationsFuture.value?.allLocationsFlattened,
    }).toList();

    data = _filter.filterLocations(
      data,
      keyword: _query.searchTrimmed,
      locale: _locale.currentLocale.languageCode.toLowerCase(),
    );

    return data.take(_config.recentLocationsLimit).toList();
  }

  Future<void> add(VPNLocation location) async {
    if (location.ipType == IPType.closest) {
      return;
    }

    // insert location at the start, removing duplicates
    final recents = {location, ...(await _future)}
        // keep some extra buffer in case some locations become unavailable
        .take(_config.recentLocationsLimit * 3)
        .toList();

    await _db.setRecentLocations(recents);
  }

  Future<void> clear() async {
    await _db.setRecentLocations(const <VPNLocation>[]);
  }

  Future<void> dispose() async {
    await _dbChangesSubscription.cancel();
  }
}
