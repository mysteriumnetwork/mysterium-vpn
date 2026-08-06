import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'favorite_ips_store.g.dart';

/// Typed notices surfaced to the view layer, which translates them.
enum FavoriteIpsNotice { limitReached }

// ignore: library_private_types_in_public_api
class FavoriteIpsStore = _FavoriteIpsStore with _$FavoriteIpsStore;

abstract class _FavoriteIpsStore with Store {
  _FavoriteIpsStore(
    this._db,
    this._availabilityService,
    this._subscription,
    this._remoteConfig,
    this._analytics,
  ) {
    // Availability is refreshed when the Favorite tab is opened (view) or
    // explicitly (refresh button / pull) — not here: the user-data stream
    // fires on every unrelated write (e.g. recents after each connect).
    // The user-data box emits on every write (recents after a connect, banners,
    // …), so ignore emissions that don't change the saved list.
    _dbChangesSubscription = _db.watchFavoriteIps().listen((saved) {
      if (_future.value != null && listEquals(_future.value, saved)) {
        return;
      }
      _future = _future.replaceOrReset(Future.value(saved));
    });
  }

  final LocalDBService _db;
  final FavoriteIpsAvailabilityService _availabilityService;
  final SubscriptionStore _subscription;
  final RemoteConfigStore _remoteConfig;
  final AnalyticsStore _analytics;

  late final StreamSubscription<List<FavoriteIp>> _dbChangesSubscription;

  @readonly
  late ObservableFuture<List<FavoriteIp>> _future = ObservableFuture(_db.getFavoriteIps());

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

    _availabilityCheckedAt = null;
    await _db.setFavoriteIps([favorite, ...favorites]);
    return true;
  }

  @action
  Future<void> remove(String ip) async {
    final favorite = favorites.firstWhereOrNull((it) => it.ip == ip);
    if (favorite == null) {
      return;
    }

    final remaining = favorites.where((it) => it.ip != ip).toList();
    _availabilityCheckedAt = null;
    await _db.setFavoriteIps(remaining);
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
    _availabilityCheckedAt = null;

    await _db.setFavoriteIps([favorite, ...favorites]);
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
      unawaited(
        _analytics.logFavoriteIpUnavailableShown(favorite, favoriteIpCount: favorites.length),
      );
    }
  }

  @action
  Future<void> clear() async {
    _availabilityCheckedAt = null;
    await _db.setFavoriteIps(const <FavoriteIp>[]);
  }

  /// How long a successful availability result is considered fresh. The tab
  /// refreshes on open, and that view can remount for reasons unrelated to
  /// favorites (the locations tree above it changing shape after a connect),
  /// so without this every remount would re-hit the endpoint.
  static const availabilityTtl = Duration(seconds: 30);

  Future<bool>? _availabilityRefresh;
  DateTime? _availabilityCheckedAt;

  /// Refreshes per-IP availability, reporting success.
  ///
  /// Concurrent callers share one request, and a result that is still fresh
  /// (see [availabilityTtl]) for the same set of IPs is reused instead of
  /// re-requesting. Pass [force] for user-triggered refreshes, which must
  /// always hit the backend. On failure the previous map is kept so favorites
  /// stay tappable and connect surfaces the error.
  Future<bool> refreshAvailability({bool force = false}) => _availabilityRefresh ??=
      _refreshAvailability(force: force).whenComplete(() => _availabilityRefresh = null);

  @action
  Future<bool> _refreshAvailability({required bool force}) async {
    final ips = favorites.map((it) => it.ip).toList();
    if (!isEnabled || ips.isEmpty) {
      return true;
    }

    final checkedAt = _availabilityCheckedAt;
    if (!force && checkedAt != null && DateTime.now().difference(checkedAt) < availabilityTtl) {
      return true;
    }

    try {
      final result = await _availabilityService.checkAvailability(ips);
      if (!mapEquals(_availability, result)) {
        _availability = ObservableMap.of(result);
      }
      _availabilityCheckedAt = DateTime.now();
      return true;
    } catch (_) {
      // keep previous availability
      return false;
    }
  }

  Future<void> dispose() async {
    await _dbChangesSubscription.cancel();
  }
}
