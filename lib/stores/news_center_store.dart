import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

part 'news_center_store.g.dart';

// ignore: library_private_types_in_public_api
class NewsCenterStore = _NewsCenterStore with _$NewsCenterStore;

/// Holds the News Center feed and its derived UI state.
///
/// [load] is called eagerly when the home header mounts (so [unreadCount] can
/// drive the bell badge before the page is opened) and again on every page
/// entry. A load never clears the previously loaded items — old data stays
/// visible while a refresh is in flight, and a failed refresh keeps the cache.
///
/// Read state is not part of the API payload: it's tracked as a set of read ids
/// (seeded from [NewsCenterService.readIds], persisted via
/// [NewsCenterService.markRead]) and unread-ness is derived from it.
abstract class _NewsCenterStore with Store {
  _NewsCenterStore(NewsCenterService service, this._logger)
    : _service = service,
      _readIds = ObservableSet.of(service.readIds());

  final NewsCenterService _service;
  final Talker _logger;

  /// Ids the user has read; drives [isRead] / [unreadCount].
  final ObservableSet<int> _readIds;

  /// The current load attempt. `null` until [load] is first called.
  @readonly
  ObservableFuture<List<NewscenterInboxListResponseItem>>? _feedFuture;

  /// The last successfully loaded feed. `null` until the first success, then
  /// retained across failed refreshes so the UI never loses data.
  @readonly
  List<NewscenterInboxListResponseItem>? _items;

  @observable
  NewsFilter selectedFilter = NewsFilter.all;

  /// Items matching [selectedFilter].
  @computed
  List<NewscenterInboxListResponseItem> get filteredItems {
    final items = _items ?? const [];
    return switch (selectedFilter) {
      NewsFilter.all => items,
      NewsFilter.incidents =>
        items.where((i) => i.category == NewscenterCategory.incident).toList(),
      NewsFilter.news => items.where((i) => i.category == NewscenterCategory.news).toList(),
      NewsFilter.offers => items.where((i) => i.category == NewscenterCategory.offer).toList(),
    };
  }

  /// Filters that currently have at least one item. [NewsFilter.all] is present
  /// whenever the feed is non-empty; each category filter only when an item of
  /// that category exists. Drives per-tab enablement (empty categories disable).
  @computed
  Set<NewsFilter> get nonEmptyFilters {
    final items = _items ?? const [];
    if (items.isEmpty) {
      return const {};
    }
    final categories = items.map((i) => i.category).toSet();
    return {
      NewsFilter.all,
      if (categories.contains(NewscenterCategory.incident)) NewsFilter.incidents,
      if (categories.contains(NewscenterCategory.news)) NewsFilter.news,
      if (categories.contains(NewscenterCategory.offer)) NewsFilter.offers,
    };
  }

  /// Unread count across the whole feed, independent of the active filter.
  @computed
  int get unreadCount => (_items ?? const []).where((i) => !isRead(i.id)).length;

  /// Whether the item with [id] has been read.
  bool isRead(num id) => _readIds.contains(id.toInt());

  /// `null` while never-loaded, `true` when loaded and empty, `false` otherwise.
  @computed
  bool? get isEmpty => _items?.isEmpty;

  /// Show the full-screen spinner only on the first-ever load with no cache.
  @computed
  bool get isInitialLoading =>
      _items == null && (_feedFuture == null || _feedFuture!.status == FutureStatus.pending);

  /// Show the error/retry state only when there is no cache to fall back on.
  @computed
  bool get hasError => _items == null && _feedFuture?.status == FutureStatus.rejected;

  /// True while a full-screen loading or error state occupies the page (no feed
  /// chrome), so callers can hide the title/tabs and center the state.
  @computed
  bool get showsFullScreenState => isInitialLoading || hasError;

  /// Loads the feed. Does not clear [_items] — a running load leaves existing
  /// data on screen. A load already in flight is not duplicated (used for the
  /// eager badge load and the on-entry load).
  @action
  Future<void> load() async {
    if (_feedFuture?.status == FutureStatus.pending) {
      return;
    }
    await _fetch();
  }

  /// Forces a fetch and reports whether fresh data was loaded — drives the
  /// pull-to-refresh snackbar. Old data is retained on failure.
  @action
  Future<bool> refresh() => _fetch();

  Future<bool> _fetch() async {
    // Future.sync converts a synchronous throw from the service into a rejected
    // future so both failure modes flip _feedFuture to rejected and are caught.
    final future = ObservableFuture(Future.sync(_service.getFeed));
    _feedFuture = future;

    try {
      _items = await future;
      return true;
    } catch (e, stackTrace) {
      // Keep any previously loaded items; the UI surfaces the failure.
      _logger.handle(e, stackTrace);
      return false;
    }
  }

  /// Marks an item as read: flips it in memory (so [isRead] / [unreadCount]
  /// update immediately) and persists it so it stays read across refreshes and
  /// launches.
  @action
  void markRead(num id) {
    final key = id.toInt();
    if (_readIds.add(key)) {
      unawaited(_service.markRead(key));
    }
  }

  /// Clears all read state, in memory and persisted (QA helper).
  @action
  Future<void> clearRead() async {
    _readIds.clear();
    await _service.clearRead();
  }
}
