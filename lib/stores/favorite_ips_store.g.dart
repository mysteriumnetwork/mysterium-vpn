// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_ips_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoriteIpsStore on _FavoriteIpsStore, Store {
  Computed<List<FavoriteIp>>? _$favoritesComputed;

  @override
  List<FavoriteIp> get favorites => (_$favoritesComputed ??= Computed<List<FavoriteIp>>(
    () => super.favorites,
    name: '_FavoriteIpsStore.favorites',
  )).value;
  Computed<List<FavoriteIp>>? _$availableFavoritesComputed;

  @override
  List<FavoriteIp> get availableFavorites =>
      (_$availableFavoritesComputed ??= Computed<List<FavoriteIp>>(
        () => super.availableFavorites,
        name: '_FavoriteIpsStore.availableFavorites',
      )).value;
  Computed<List<FavoriteIp>>? _$unavailableFavoritesComputed;

  @override
  List<FavoriteIp> get unavailableFavorites =>
      (_$unavailableFavoritesComputed ??= Computed<List<FavoriteIp>>(
        () => super.unavailableFavorites,
        name: '_FavoriteIpsStore.unavailableFavorites',
      )).value;
  Computed<bool>? _$isEnabledComputed;

  @override
  bool get isEnabled => (_$isEnabledComputed ??= Computed<bool>(
    () => super.isEnabled,
    name: '_FavoriteIpsStore.isEnabled',
  )).value;
  Computed<bool>? _$canAddMoreComputed;

  @override
  bool get canAddMore => (_$canAddMoreComputed ??= Computed<bool>(
    () => super.canAddMore,
    name: '_FavoriteIpsStore.canAddMore',
  )).value;

  late final _$_futureAtom = Atom(name: '_FavoriteIpsStore._future', context: context);

  ObservableFuture<List<FavoriteIp>> get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<List<FavoriteIp>> get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(ObservableFuture<List<FavoriteIp>> value) {
    _$_futureAtom.reportWrite(value, __futureIsInitialized ? super._future : null, () {
      super._future = value;
      __futureIsInitialized = true;
    });
  }

  late final _$_availabilityAtom = Atom(name: '_FavoriteIpsStore._availability', context: context);

  ObservableMap<String, bool> get availability {
    _$_availabilityAtom.reportRead();
    return super._availability;
  }

  @override
  ObservableMap<String, bool> get _availability => availability;

  @override
  set _availability(ObservableMap<String, bool> value) {
    _$_availabilityAtom.reportWrite(value, super._availability, () {
      super._availability = value;
    });
  }

  late final _$_noticeAtom = Atom(name: '_FavoriteIpsStore._notice', context: context);

  FavoriteIpsNotice? get notice {
    _$_noticeAtom.reportRead();
    return super._notice;
  }

  @override
  FavoriteIpsNotice? get _notice => notice;

  @override
  set _notice(FavoriteIpsNotice? value) {
    _$_noticeAtom.reportWrite(value, super._notice, () {
      super._notice = value;
    });
  }

  late final _$_connectingIpAtom = Atom(name: '_FavoriteIpsStore._connectingIp', context: context);

  String? get connectingIp {
    _$_connectingIpAtom.reportRead();
    return super._connectingIp;
  }

  @override
  String? get _connectingIp => connectingIp;

  @override
  set _connectingIp(String? value) {
    _$_connectingIpAtom.reportWrite(value, super._connectingIp, () {
      super._connectingIp = value;
    });
  }

  late final _$addAsyncAction = AsyncAction('_FavoriteIpsStore.add', context: context);

  @override
  Future<bool> add(FavoriteIp favorite) {
    return _$addAsyncAction.run(() => super.add(favorite));
  }

  late final _$removeAsyncAction = AsyncAction('_FavoriteIpsStore.remove', context: context);

  @override
  Future<void> remove(String ip) {
    return _$removeAsyncAction.run(() => super.remove(ip));
  }

  late final _$undoRemoveAsyncAction = AsyncAction(
    '_FavoriteIpsStore.undoRemove',
    context: context,
  );

  @override
  Future<bool> undoRemove() {
    return _$undoRemoveAsyncAction.run(() => super.undoRemove());
  }

  late final _$clearAsyncAction = AsyncAction('_FavoriteIpsStore.clear', context: context);

  @override
  Future<void> clear() {
    return _$clearAsyncAction.run(() => super.clear());
  }

  late final _$_refreshAvailabilityAsyncAction = AsyncAction(
    '_FavoriteIpsStore._refreshAvailability',
    context: context,
  );

  @override
  Future<bool> _refreshAvailability({required bool force}) {
    return _$_refreshAvailabilityAsyncAction.run(() => super._refreshAvailability(force: force));
  }

  late final _$_FavoriteIpsStoreActionController = ActionController(
    name: '_FavoriteIpsStore',
    context: context,
  );

  @override
  void clearNotice() {
    final _$actionInfo = _$_FavoriteIpsStoreActionController.startAction(
      name: '_FavoriteIpsStore.clearNotice',
    );
    try {
      return super.clearNotice();
    } finally {
      _$_FavoriteIpsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConnectingIp(String? ip) {
    final _$actionInfo = _$_FavoriteIpsStoreActionController.startAction(
      name: '_FavoriteIpsStore.setConnectingIp',
    );
    try {
      return super.setConnectingIp(ip);
    } finally {
      _$_FavoriteIpsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markUnavailable(String ip) {
    final _$actionInfo = _$_FavoriteIpsStoreActionController.startAction(
      name: '_FavoriteIpsStore.markUnavailable',
    );
    try {
      return super.markUnavailable(ip);
    } finally {
      _$_FavoriteIpsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void recordConnectOutcome(FavoriteIp favorite, {required String? connectedIp}) {
    final _$actionInfo = _$_FavoriteIpsStoreActionController.startAction(
      name: '_FavoriteIpsStore.recordConnectOutcome',
    );
    try {
      return super.recordConnectOutcome(favorite, connectedIp: connectedIp);
    } finally {
      _$_FavoriteIpsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favorites: ${favorites},
availableFavorites: ${availableFavorites},
unavailableFavorites: ${unavailableFavorites},
isEnabled: ${isEnabled},
canAddMore: ${canAddMore}
    ''';
  }
}
