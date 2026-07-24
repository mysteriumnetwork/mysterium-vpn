// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_center_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsCenterStore on _NewsCenterStore, Store {
  Computed<List<NewscenterInboxListResponseItem>>? _$filteredItemsComputed;

  @override
  List<NewscenterInboxListResponseItem> get filteredItems =>
      (_$filteredItemsComputed ??= Computed<List<NewscenterInboxListResponseItem>>(
        () => super.filteredItems,
        name: '_NewsCenterStore.filteredItems',
      )).value;
  Computed<Set<NewsFilter>>? _$nonEmptyFiltersComputed;

  @override
  Set<NewsFilter> get nonEmptyFilters => (_$nonEmptyFiltersComputed ??= Computed<Set<NewsFilter>>(
    () => super.nonEmptyFilters,
    name: '_NewsCenterStore.nonEmptyFilters',
  )).value;
  Computed<int>? _$unreadCountComputed;

  @override
  int get unreadCount => (_$unreadCountComputed ??= Computed<int>(
    () => super.unreadCount,
    name: '_NewsCenterStore.unreadCount',
  )).value;
  Computed<bool?>? _$isEmptyComputed;

  @override
  bool? get isEmpty => (_$isEmptyComputed ??= Computed<bool?>(
    () => super.isEmpty,
    name: '_NewsCenterStore.isEmpty',
  )).value;
  Computed<bool>? _$isInitialLoadingComputed;

  @override
  bool get isInitialLoading => (_$isInitialLoadingComputed ??= Computed<bool>(
    () => super.isInitialLoading,
    name: '_NewsCenterStore.isInitialLoading',
  )).value;
  Computed<bool>? _$feedFetchFailedComputed;

  @override
  bool get feedFetchFailed => (_$feedFetchFailedComputed ??= Computed<bool>(
    () => super.feedFetchFailed,
    name: '_NewsCenterStore.feedFetchFailed',
  )).value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: '_NewsCenterStore.hasError',
  )).value;
  Computed<bool>? _$showsFullScreenStateComputed;

  @override
  bool get showsFullScreenState => (_$showsFullScreenStateComputed ??= Computed<bool>(
    () => super.showsFullScreenState,
    name: '_NewsCenterStore.showsFullScreenState',
  )).value;

  late final _$_feedFutureAtom = Atom(name: '_NewsCenterStore._feedFuture', context: context);

  ObservableFuture<List<NewscenterInboxListResponseItem>>? get feedFuture {
    _$_feedFutureAtom.reportRead();
    return super._feedFuture;
  }

  @override
  ObservableFuture<List<NewscenterInboxListResponseItem>>? get _feedFuture => feedFuture;

  @override
  set _feedFuture(ObservableFuture<List<NewscenterInboxListResponseItem>>? value) {
    _$_feedFutureAtom.reportWrite(value, super._feedFuture, () {
      super._feedFuture = value;
    });
  }

  late final _$_itemsAtom = Atom(name: '_NewsCenterStore._items', context: context);

  List<NewscenterInboxListResponseItem>? get items {
    _$_itemsAtom.reportRead();
    return super._items;
  }

  @override
  List<NewscenterInboxListResponseItem>? get _items => items;

  @override
  set _items(List<NewscenterInboxListResponseItem>? value) {
    _$_itemsAtom.reportWrite(value, super._items, () {
      super._items = value;
    });
  }

  late final _$selectedFilterAtom = Atom(name: '_NewsCenterStore.selectedFilter', context: context);

  @override
  NewsFilter get selectedFilter {
    _$selectedFilterAtom.reportRead();
    return super.selectedFilter;
  }

  @override
  set selectedFilter(NewsFilter value) {
    _$selectedFilterAtom.reportWrite(value, super.selectedFilter, () {
      super.selectedFilter = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction('_NewsCenterStore.load', context: context);

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$clearReadAsyncAction = AsyncAction('_NewsCenterStore.clearRead', context: context);

  @override
  Future<void> clearRead() {
    return _$clearReadAsyncAction.run(() => super.clearRead());
  }

  late final _$_NewsCenterStoreActionController = ActionController(
    name: '_NewsCenterStore',
    context: context,
  );

  @override
  Future<bool> refresh() {
    final _$actionInfo = _$_NewsCenterStoreActionController.startAction(
      name: '_NewsCenterStore.refresh',
    );
    try {
      return super.refresh();
    } finally {
      _$_NewsCenterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markRead(num id) {
    final _$actionInfo = _$_NewsCenterStoreActionController.startAction(
      name: '_NewsCenterStore.markRead',
    );
    try {
      return super.markRead(id);
    } finally {
      _$_NewsCenterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedFilter: ${selectedFilter},
filteredItems: ${filteredItems},
nonEmptyFilters: ${nonEmptyFilters},
unreadCount: ${unreadCount},
isEmpty: ${isEmpty},
isInitialLoading: ${isInitialLoading},
feedFetchFailed: ${feedFetchFailed},
hasError: ${hasError},
showsFullScreenState: ${showsFullScreenState}
    ''';
  }
}
