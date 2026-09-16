import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'favorite_ips_store.g.dart';

/// Typed notices surfaced to the view layer, which translates them.
enum FavoriteIpsNotice { limitReached }

// ignore: library_private_types_in_public_api
class FavoriteIpsStore = _FavoriteIpsStore with _$FavoriteIpsStore;

abstract class _FavoriteIpsStore with Store {
  _FavoriteIpsStore(this._repository, this._subscription, this._remoteConfig, this._analytics) {
    // Availability is refreshed when the Favorite tab is opened (view) or
    // explicitly (refresh button / pull) — not here: the user-data stream
    // fires on every unrelated write (e.g. recents after each connect).
    // The user-data box emits on every write (recents after a connect, banners,
    // …), so ignore emissions that don't change the saved list.
    _dbChangesSubscription = _repository.watch().listen((saved) {
      if (_future.value != null && listEquals(_future.value, saved)) {
        return;
      }
      // The list changed, so cached availability no longer covers it. The
      // mutators reset this eagerly to close the window before this stream
      // catches up; this covers changes that did not originate there.
      _repository.invalidateAvailability();
      _future = _future.replaceOrReset(Future.value(saved));
    });
  }

  final FavoriteIpsRepository _repository;
  final SubscriptionStore _subscription;
  final RemoteConfigStore _remoteConfig;
  final AnalyticsStore _analytics;

  late final StreamSubscription<List<FavoriteIp>> _dbChangesSubscription;

  @readonly
  late ObservableFuture<List<FavoriteIp>> _future = ObservableFuture(_repository.load());

  /// Availability by IP, updated by [refreshAvailability]. IPs missing from
  /// the map are treated as available.
  @readonly
  ObservableMap<String, bool> _availability = ObservableMap();

  @readonly
  FavoriteIpsNotice? _notice;

  /// IP of the favorite a connect attempt is in flight for; set by the view
  /// so the matching card can render its connecting state.
  @readonly
  String? _connectingIp;

  FavoriteIp? _lastRemoved;

  @computed
  List<FavoriteIp> get favorites => _future.value ?? const <FavoriteIp>[];

  @computed
  List<FavoriteIp> get availableFavorites =>
      favorites.where((it) => _availability[it.ip] ?? true).toList();

  @computed
  List<FavoriteIp> get unavailableFavorites =>
      favorites.where((it) => !(_availability[it.ip] ?? true)).toList();

  /// Kill-switch and plan allowance combined.
  @computed
  bool get isEnabled => _remoteConfig.favoriteLocationsEnabled && _subscription.favoriteIpsAllowed;

  @computed
  bool get canAddMore => favorites.length < _subscription.favoriteIpsLimit;

  bool isFavorite(String ip) => favorites.any((it) => it.ip == ip);

  /// Saves [favorite], reporting whether it was added — false on a duplicate
  /// or at the limit (which emits [FavoriteIpsNotice.limitReached]).
  @action
  Future<bool> add(FavoriteIp favorite) async {
    if (isFavorite(favorite.ip)) {
      return false;
    }

    // The event is the tap, so it is logged before the limit check — that is
    // what makes the limit-reached rate measurable.
    unawaited(_analytics.logFavoriteIpAdd(favorite, favoriteIpCount: favorites.length));

    if (!canAddMore) {
      _notice = FavoriteIpsNotice.limitReached;
      return false;
    }

    _repository.invalidateAvailability();
    await _repository.save([favorite, ...favorites]);
    return true;
  }

  @action
  Future<void> remove(String ip) async {
    final favorite = favorites.firstWhereOrNull((it) => it.ip == ip);
    if (favorite == null) {
      return;
    }

    final remaining = favorites.where((it) => it.ip != ip).toList();
    _repository.invalidateAvailability();
    await _repository.save(remaining);
    _lastRemoved = favorite;
    unawaited(
      _analytics.logFavoriteIpRemoved(
        favorite,
        favoriteIpCount: remaining.length,
        availabilityState: _availabilityState(ip),
      ),
    );
  }

  /// Restores the last removed favorite. Returns whether anything was
  /// restored so the view can chain the "added" toast.
  @action
  Future<bool> undoRemove() async {
    final favorite = _lastRemoved;
    if (favorite == null || isFavorite(favorite.ip) || !canAddMore) {
      return false;
    }
    _lastRemoved = null;
    _repository.invalidateAvailability();

    await _repository.save([favorite, ...favorites]);
    unawaited(_analytics.logFavoriteIpUndoRemove());
    return true;
  }

  @action
  void clearNotice() {
    _notice = null;
  }

  @action
  // ignore: use_setters_to_change_properties
  void setConnectingIp(String? ip) {
    _connectingIp = ip;
  }

  /// Analytics label for an IP's current availability.
  String _availabilityState(String ip) => (_availability[ip] ?? true) ? 'available' : 'unavailable';

  /// Logs a connect tap, labelled with the IP's actual availability.
  void recordConnectClicked(FavoriteIp favorite) {
    unawaited(
      _analytics.logFavoriteIpConnectClicked(
        favorite,
        favoriteIpCount: favorites.length,
        availabilityState: _availabilityState(favorite.ip),
      ),
    );
  }

  /// Marks a favorite unavailable after a failed connect attempt to it.
  @action
  void markUnavailable(String ip) {
    _availability[ip] = false;
  }

  /// Records the outcome of a finished connect attempt to [favorite]. Judged
  /// by the IP the connection ended on — `isConnected` lags behind (it flips
  /// via the status stream after the connect future completes).
  @action
  void recordConnectOutcome(FavoriteIp favorite, {required String? connectedIp}) {
    if (connectedIp == favorite.ip) {
      unawaited(
        _analytics.logFavoriteIpConnectionSucceeded(favorite, favoriteIpCount: favorites.length),
      );
    } else {
      markUnavailable(favorite.ip);
      unawaited(_analytics.logFavoriteIpUnknownShown(favorite, favoriteIpCount: favorites.length));
    }
  }

  @action
  Future<void> clear() async {
    _repository.invalidateAvailability();
    await _repository.save(const <FavoriteIp>[]);
  }

  /// Refreshes per-IP availability, reporting success.
  ///
  /// Concurrent callers share one request, and a result that is still fresh
  /// (see `LocalFavoriteIpsRepository.availabilityTtl`) is reused instead of
  /// re-requesting. Pass [force] for user-triggered refreshes, which must
  /// always hit the backend. On failure the previous map is kept so favorites
  /// stay tappable and connect surfaces the error.
  Future<bool> refreshAvailability({bool force = false}) => _refreshAvailability(force: force);

  @action
  Future<bool> _refreshAvailability({required bool force}) async {
    final checkedFavorites = List<FavoriteIp>.of(favorites);
    final ips = checkedFavorites.map((it) => it.ip).toList();
    if (!isEnabled || ips.isEmpty) {
      return true;
    }

    try {
      final result = await _repository.availability(ips, force: force);
      // null means the previous result is still fresh — keep what we have, so
      // a locally marked-unavailable IP survives a remount.
      if (result == null) {
        return true;
      }
      if (!mapEquals(_availability, result)) {
        _availability = ObservableMap.of(result);
      }
      _logUnavailableShown(result, checkedFavorites);
      return true;
    } catch (_) {
      // keep previous availability
      return false;
    }
  }

  void _logUnavailableShown(Map<String, bool> availability, List<FavoriteIp> checkedFavorites) {
    final count = checkedFavorites.length;
    for (final favorite in checkedFavorites) {
      if (availability[favorite.ip] == false) {
        unawaited(_analytics.logFavoriteIpUnavailableShown(favorite, favoriteIpCount: count));
      }
    }
  }

  Future<void> dispose() async {
    await _dbChangesSubscription.cancel();
  }
}
