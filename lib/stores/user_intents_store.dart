import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:talker/talker.dart';

part 'user_intents_store.g.dart';

// ignore: library_private_types_in_public_api
class UserIntentsStore = _UserIntentsStore with _$UserIntentsStore;

abstract class _UserIntentsStore with Store {
  _UserIntentsStore(
    this._apiService,
    this._realIPInfoStore,
    this._locationsStore,
    this._logger,
  ) {
    autorun((_) {
      _apiIntentsStream.value;
    });

    reaction((_) => _locationsStore.availableCountries, (_) {
      _localIntentsFuture = _localIntentsFuture.replace(_fetchLocalIntents());
    });

    reaction((_) => _realIPInfoStore.infoFuture.value, (_) {
      _localIntentsFuture = _localIntentsFuture.replace(_fetchLocalIntents());
    });
  }

  final ApiService _apiService;
  final RealIPInfoStore _realIPInfoStore;
  final LocationsStore _locationsStore;
  final Talker _logger;

  @readonly
  late ObservableStream<Set<UserIntent>> _apiIntentsStream = ObservableStream(_watchAPIIntents());

  @readonly
  late ObservableFuture<Set<UserIntent>> _localIntentsFuture =
      ObservableFuture(_fetchLocalIntents());

  @computed
  Set<UserIntent> get intents => {
        ...?_apiIntentsStream.value,
        ...?_localIntentsFuture.value,
      };

  @computed
  bool get isLoading =>
      _apiIntentsStream.status == StreamStatus.waiting ||
      _localIntentsFuture.status == FutureStatus.pending;

  Future<Set<UserIntent>> _fetchLocalIntents() async {
    final info = await _realIPInfoStore.infoFuture;
    final myCountry = info?.country;

    final countries = _locationsStore.availableCountries;
    if (myCountry != null && countries.contains(myCountry)) {
      return {UserIntent.nearestLocation};
    } else {
      return const <UserIntent>{};
    }
  }

  Future<Set<UserIntent>?> _fetchAPIIntents() async {
    try {
      return await _apiService.fetchUserIntents();
    } catch (error, stack) {
      _logger.handle(error, stack);
      return null;
    }
  }

  Stream<Set<UserIntent>> _watchAPIIntents() async* {
    yield (await _fetchAPIIntents()) ?? const <UserIntent>{};
    yield* Stream.periodic(const Duration(seconds: 2))
        .asyncMap((_) async => (await _fetchAPIIntents()) ?? const <UserIntent>{});
  }

  Future<void> dispose() async {
    await _apiIntentsStream.close();
  }
}
