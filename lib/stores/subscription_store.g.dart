// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionStore on _SubscriptionStore, Store {
  Computed<bool?>? _$isSubscribedComputed;

  @override
  bool? get isSubscribed => (_$isSubscribedComputed ??=
          Computed<bool?>(() => super.isSubscribed, name: '_SubscriptionStore.isSubscribed'))
      .value;
  Computed<PurchasableProduct>? _$monthlyProductComputed;

  @override
  PurchasableProduct get monthlyProduct =>
      (_$monthlyProductComputed ??= Computed<PurchasableProduct>(() => super.monthlyProduct,
              name: '_SubscriptionStore.monthlyProduct'))
          .value;
  Computed<PurchasableProduct>? _$highlightedProductComputed;

  @override
  PurchasableProduct get highlightedProduct =>
      (_$highlightedProductComputed ??= Computed<PurchasableProduct>(() => super.highlightedProduct,
              name: '_SubscriptionStore.highlightedProduct'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_SubscriptionStore.isLoading'))
      .value;

  late final _$isAvailableFutureAtom =
      Atom(name: '_SubscriptionStore.isAvailableFuture', context: context);

  @override
  ObservableFuture<api.SubscriptionConfigResponse>? get isAvailableFuture {
    _$isAvailableFutureAtom.reportRead();
    return super.isAvailableFuture;
  }

  @override
  set isAvailableFuture(ObservableFuture<api.SubscriptionConfigResponse>? value) {
    _$isAvailableFutureAtom.reportWrite(value, super.isAvailableFuture, () {
      super.isAvailableFuture = value;
    });
  }

  late final _$verifySubscriptionFutureAtom =
      Atom(name: '_SubscriptionStore.verifySubscriptionFuture', context: context);

  @override
  ObservableFuture<Subscription>? get verifySubscriptionFuture {
    _$verifySubscriptionFutureAtom.reportRead();
    return super.verifySubscriptionFuture;
  }

  @override
  set verifySubscriptionFuture(ObservableFuture<Subscription>? value) {
    _$verifySubscriptionFutureAtom.reportWrite(value, super.verifySubscriptionFuture, () {
      super.verifySubscriptionFuture = value;
    });
  }

  late final _$subscriptionFutureAtom =
      Atom(name: '_SubscriptionStore.subscriptionFuture', context: context);

  @override
  ObservableFuture<Subscription>? get subscriptionFuture {
    _$subscriptionFutureAtom.reportRead();
    return super.subscriptionFuture;
  }

  @override
  set subscriptionFuture(ObservableFuture<Subscription>? value) {
    _$subscriptionFutureAtom.reportWrite(value, super.subscriptionFuture, () {
      super.subscriptionFuture = value;
    });
  }

  late final _$_subscriptionAtom = Atom(name: '_SubscriptionStore._subscription', context: context);

  Subscription? get subscription {
    _$_subscriptionAtom.reportRead();
    return super._subscription;
  }

  @override
  Subscription? get _subscription => subscription;

  @override
  set _subscription(Subscription? value) {
    _$_subscriptionAtom.reportWrite(value, super._subscription, () {
      super._subscription = value;
    });
  }

  late final _$_expiredAtom = Atom(name: '_SubscriptionStore._expired', context: context);

  bool? get expired {
    _$_expiredAtom.reportRead();
    return super._expired;
  }

  @override
  bool? get _expired => expired;

  @override
  set _expired(bool? value) {
    _$_expiredAtom.reportWrite(value, super._expired, () {
      super._expired = value;
    });
  }

  late final _$_isAvailableAtom = Atom(name: '_SubscriptionStore._isAvailable', context: context);

  StoreState get isAvailable {
    _$_isAvailableAtom.reportRead();
    return super._isAvailable;
  }

  @override
  StoreState get _isAvailable => isAvailable;

  @override
  set _isAvailable(StoreState value) {
    _$_isAvailableAtom.reportWrite(value, super._isAvailable, () {
      super._isAvailable = value;
    });
  }

  late final _$_purchasedProductIdAtom =
      Atom(name: '_SubscriptionStore._purchasedProductId', context: context);

  String? get purchasedProductId {
    _$_purchasedProductIdAtom.reportRead();
    return super._purchasedProductId;
  }

  @override
  String? get _purchasedProductId => purchasedProductId;

  @override
  set _purchasedProductId(String? value) {
    _$_purchasedProductIdAtom.reportWrite(value, super._purchasedProductId, () {
      super._purchasedProductId = value;
    });
  }

  late final _$_subscriptionConfigAtom =
      Atom(name: '_SubscriptionStore._subscriptionConfig', context: context);

  api.SubscriptionConfigResponse? get subscriptionConfig {
    _$_subscriptionConfigAtom.reportRead();
    return super._subscriptionConfig;
  }

  @override
  api.SubscriptionConfigResponse? get _subscriptionConfig => subscriptionConfig;

  @override
  set _subscriptionConfig(api.SubscriptionConfigResponse? value) {
    _$_subscriptionConfigAtom.reportWrite(value, super._subscriptionConfig, () {
      super._subscriptionConfig = value;
    });
  }

  late final _$_subscriptonStatusAtom =
      Atom(name: '_SubscriptionStore._subscriptonStatus', context: context);

  SubscriptionStatus? get subscriptonStatus {
    _$_subscriptonStatusAtom.reportRead();
    return super._subscriptonStatus;
  }

  @override
  SubscriptionStatus? get _subscriptonStatus => subscriptonStatus;

  @override
  set _subscriptonStatus(SubscriptionStatus? value) {
    _$_subscriptonStatusAtom.reportWrite(value, super._subscriptonStatus, () {
      super._subscriptonStatus = value;
    });
  }

  late final _$_lastPurchaseAtom = Atom(name: '_SubscriptionStore._lastPurchase', context: context);

  PurchaseDetails? get lastPurchase {
    _$_lastPurchaseAtom.reportRead();
    return super._lastPurchase;
  }

  @override
  PurchaseDetails? get _lastPurchase => lastPurchase;

  @override
  set _lastPurchase(PurchaseDetails? value) {
    _$_lastPurchaseAtom.reportWrite(value, super._lastPurchase, () {
      super._lastPurchase = value;
    });
  }

  late final _$_productsAtom = Atom(name: '_SubscriptionStore._products', context: context);

  ObservableList<PurchasableProduct> get products {
    _$_productsAtom.reportRead();
    return super._products;
  }

  @override
  ObservableList<PurchasableProduct> get _products => products;

  @override
  set _products(ObservableList<PurchasableProduct> value) {
    _$_productsAtom.reportWrite(value, super._products, () {
      super._products = value;
    });
  }

  late final _$initStoreAsyncAction = AsyncAction('_SubscriptionStore.initStore', context: context);

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  late final _$fetchSubscriptionAsyncAction =
      AsyncAction('_SubscriptionStore.fetchSubscription', context: context);

  @override
  Future<bool> fetchSubscription() {
    return _$fetchSubscriptionAsyncAction.run(() => super.fetchSubscription());
  }

  late final _$isSubscriptionActiveAsyncAction =
      AsyncAction('_SubscriptionStore.isSubscriptionActive', context: context);

  @override
  Future<bool> isSubscriptionActive() {
    return _$isSubscriptionActiveAsyncAction.run(() => super.isSubscriptionActive());
  }

  late final _$getSubscriptionsConfigAsyncAction =
      AsyncAction('_SubscriptionStore.getSubscriptionsConfig', context: context);

  @override
  Future<void> getSubscriptionsConfig() {
    return _$getSubscriptionsConfigAsyncAction.run(() => super.getSubscriptionsConfig());
  }

  late final _$getProductsDetailsAsyncAction =
      AsyncAction('_SubscriptionStore.getProductsDetails', context: context);

  @override
  Future<void> getProductsDetails() {
    return _$getProductsDetailsAsyncAction.run(() => super.getProductsDetails());
  }

  late final _$subscribeToPackageAsyncAction =
      AsyncAction('_SubscriptionStore.subscribeToPackage', context: context);

  @override
  Future<void> subscribeToPackage({required ProductDetails product}) {
    return _$subscribeToPackageAsyncAction.run(() => super.subscribeToPackage(product: product));
  }

  late final _$redeemCodeAsyncAction =
      AsyncAction('_SubscriptionStore.redeemCode', context: context);

  @override
  Future<void> redeemCode() {
    return _$redeemCodeAsyncAction.run(() => super.redeemCode());
  }

  late final _$_handlePurchaseAsyncAction =
      AsyncAction('_SubscriptionStore._handlePurchase', context: context);

  @override
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) {
    return _$_handlePurchaseAsyncAction.run(() => super._handlePurchase(purchaseDetails));
  }

  late final _$verifyPurchaseAsyncAction =
      AsyncAction('_SubscriptionStore.verifyPurchase', context: context);

  @override
  Future<void> verifyPurchase(String productId, String price, PurchaseDetails purchaseDetails) {
    return _$verifyPurchaseAsyncAction
        .run(() => super.verifyPurchase(productId, price, purchaseDetails));
  }

  late final _$retryVerificationProcessAsyncAction =
      AsyncAction('_SubscriptionStore.retryVerificationProcess', context: context);

  @override
  Future<void> retryVerificationProcess() {
    return _$retryVerificationProcessAsyncAction.run(() => super.retryVerificationProcess());
  }

  late final _$_SubscriptionStoreActionController =
      ActionController(name: '_SubscriptionStore', context: context);

  @override
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    final _$actionInfo = _$_SubscriptionStoreActionController.startAction(
        name: '_SubscriptionStore._onPurchaseUpdate');
    try {
      return super._onPurchaseUpdate(purchaseDetailsList);
    } finally {
      _$_SubscriptionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateStreamOnDone() {
    final _$actionInfo = _$_SubscriptionStoreActionController.startAction(
        name: '_SubscriptionStore._updateStreamOnDone');
    try {
      return super._updateStreamOnDone();
    } finally {
      _$_SubscriptionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateStreamOnError(dynamic error) {
    final _$actionInfo = _$_SubscriptionStoreActionController.startAction(
        name: '_SubscriptionStore._updateStreamOnError');
    try {
      return super._updateStreamOnError(error);
    } finally {
      _$_SubscriptionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isAvailableFuture: ${isAvailableFuture},
verifySubscriptionFuture: ${verifySubscriptionFuture},
subscriptionFuture: ${subscriptionFuture},
isSubscribed: ${isSubscribed},
monthlyProduct: ${monthlyProduct},
highlightedProduct: ${highlightedProduct},
isLoading: ${isLoading}
    ''';
  }
}
