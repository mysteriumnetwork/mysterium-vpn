import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'recent_locations_store.g.dart';

// ignore: library_private_types_in_public_api
class RecentLocationsStore = _RecentLocationsStore with _$RecentLocationsStore;

abstract class _RecentLocationsStore with Store {
  _RecentLocationsStore(
    this._repository,
    this._filter,
    this._query,
    this._config,
    this._locations,
    this._locale,
  ) {
    _dbChangesSubscription = _repository.watch().listen((locations) {
      _future = _future.replaceOrReset(Future.value(locations));
    });
  }

  final RecentLocationsRepository _repository;
  final FilterService _filter;

  final LocationsQueryStore _query;
  final RemoteConfigStore _config;
  final LocationsStore _locations;
  final LocaleStore _locale;

  late final StreamSubscription<List<VPNLocation>> _dbChangesSubscription;

  @readonly
  late ObservableFuture<List<VPNLocation>> _future = ObservableFuture(_repository.load());

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

    await _repository.save(recents);
  }

  Future<void> clear() => _repository.clear();

  Future<void> dispose() async {
    await _dbChangesSubscription.cancel();
  }
}
