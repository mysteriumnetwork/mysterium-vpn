import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'user_intents_store.g.dart';

// ignore: library_private_types_in_public_api
class UserIntentsStore = _UserIntentsStore with _$UserIntentsStore;

abstract class _UserIntentsStore with Store {
  _UserIntentsStore(
    this._apiService,
    this._realIPInfoStore,
    this._locationsStore,
    this._remoteConfigStore,
  ) {
    _reactionDisposers.addAll([
      reaction((_) => _locationsStore.countryCodes, (_) {
        _localIntentsFuture = _localIntentsFuture.replace(_fetchLocalIntents());
      }),
      reaction((_) => _realIPInfoStore.infoFuture.value, (_) {
        _localIntentsFuture = _localIntentsFuture.replace(_fetchLocalIntents());
      }),
      reaction((_) => (_apiIntentsFuture, _localIntentsFuture), (_) {
        _intentsFuture = _intentsFuture.replace(_fetchIntents());
      }),
    ]);

    _streamSubscriptions.addAll([
      _watchAPIIntents().listen((data) {
        _apiIntentsFuture = _apiIntentsFuture.replaceOrReset(Future.value(data));
      }),
    ]);
  }

  final ApiService _apiService;
  final RealIPInfoStore _realIPInfoStore;
  final LocationsStore _locationsStore;
  final RemoteConfigStore _remoteConfigStore;
  final List<StreamSubscription<Object?>> _streamSubscriptions = [];
  final List<ReactionDisposer> _reactionDisposers = [];

  @observable
  UserIntent? userIntent;

  @computed
  Set<UserIntent> get userIntents {
    final intents = {...UserIntent.values};
    final myCountry = _realIPInfoStore.info?.country;

    if (myCountry != null) {
      final availableCountries = {
        ...?_locationsStore.dcLocationsFuture.value?.allLocations,
        ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
      };

      if (availableCountries.none((it) => it.countryCode == myCountry)) {
        intents.remove(UserIntent.nearestLocation);
      }
    } else {
      intents.remove(UserIntent.nearestLocation);
    }

    return intents;
  }

  @readonly
  late ObservableFuture<Set<UserIntent>> _apiIntentsFuture =
      ObservableFuture(_apiService.fetchUserIntents());

  @readonly
  late ObservableFuture<Set<UserIntent>> _localIntentsFuture =
      ObservableFuture(_fetchLocalIntents());

  @readonly
  late ObservableFuture<Set<UserIntent>> _intentsFuture = ObservableFuture(_fetchIntents());

  @computed
  Set<UserIntent> get intents => _intentsFuture.value ?? const <UserIntent>{};

  Future<Set<UserIntent>> _fetchLocalIntents() async {
    final info = await _realIPInfoStore.infoFuture;
    final myCountry = info?.country;

    final countries = _locationsStore.countryCodes;
    if (myCountry != null && countries.contains(myCountry)) {
      return {UserIntent.nearestLocation};
    } else {
      return const <UserIntent>{};
    }
  }

  Future<Set<UserIntent>> _fetchIntents() async {
    final [apiIntents, localIntents] = await Future.wait([_apiIntentsFuture, _localIntentsFuture]);
    final merged = {...apiIntents, ...localIntents};

    return merged.where((it) => !_remoteConfigStore.userIntentBlacklist.contains(it)).toSet();
  }

  Stream<Set<UserIntent>> _watchAPIIntents() async* {
    await _apiIntentsFuture;
    yield* Stream.periodic(_remoteConfigStore.userIntentsRefreshInterval)
        .asyncMap((_) => _apiService.fetchUserIntents());
  }

  Future<void> dispose() async {
    for (final disposer in _reactionDisposers) {
      disposer();
    }
    await Future.wait(_streamSubscriptions.map((it) => it.cancel()));
  }
}
