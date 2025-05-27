// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionStore on _SubscriptionStore, Store {
  Computed<PurchasableProduct?>? _$monthlyProductComputed;

  @override
  PurchasableProduct? get monthlyProduct =>
      (_$monthlyProductComputed ??= Computed<PurchasableProduct?>(() => super.monthlyProduct,
              name: '_SubscriptionStore.monthlyProduct'))
          .value;
  Computed<PurchasableProduct?>? _$highlightedProductComputed;

  @override
  PurchasableProduct? get highlightedProduct => (_$highlightedProductComputed ??=
          Computed<PurchasableProduct?>(() => super.highlightedProduct,
              name: '_SubscriptionStore.highlightedProduct'))
      .value;
  Computed<bool?>? _$isSubscribedComputed;

  @override
  bool? get isSubscribed => (_$isSubscribedComputed ??=
          Computed<bool?>(() => super.isSubscribed, name: '_SubscriptionStore.isSubscribed'))
      .value;
  Computed<bool>? _$isSubscriptionLoadingComputed;

  @override
  bool get isSubscriptionLoading =>
      (_$isSubscriptionLoadingComputed ??= Computed<bool>(() => super.isSubscriptionLoading,
              name: '_SubscriptionStore.isSubscriptionLoading'))
          .value;
  Computed<StoreState>? _$storeStateComputed;

  @override
  StoreState get storeState => (_$storeStateComputed ??=
          Computed<StoreState>(() => super.storeState, name: '_SubscriptionStore.storeState'))
      .value;

  late final _$_subscriptionFutureAtom =
      Atom(name: '_SubscriptionStore._subscriptionFuture', context: context);

  ObservableFuture<Subscription> get subscriptionFuture {
    _$_subscriptionFutureAtom.reportRead();
    return super._subscriptionFuture;
  }

  @override
  ObservableFuture<Subscription> get _subscriptionFuture => subscriptionFuture;

  bool __subscriptionFutureIsInitialized = false;

  @override
  set _subscriptionFuture(ObservableFuture<Subscription> value) {
    _$_subscriptionFutureAtom.reportWrite(
        value, __subscriptionFutureIsInitialized ? super._subscriptionFuture : null, () {
      super._subscriptionFuture = value;
      __subscriptionFutureIsInitialized = true;
    });
  }

  late final _$_subscriptionConfigFutureAtom =
      Atom(name: '_SubscriptionStore._subscriptionConfigFuture', context: context);

  ObservableFuture<api.SubscriptionConfigResponse?> get subscriptionConfigFuture {
    _$_subscriptionConfigFutureAtom.reportRead();
    return super._subscriptionConfigFuture;
  }

  @override
  ObservableFuture<api.SubscriptionConfigResponse?> get _subscriptionConfigFuture =>
      subscriptionConfigFuture;

  bool __subscriptionConfigFutureIsInitialized = false;

  @override
  set _subscriptionConfigFuture(ObservableFuture<api.SubscriptionConfigResponse?> value) {
    _$_subscriptionConfigFutureAtom.reportWrite(
        value, __subscriptionConfigFutureIsInitialized ? super._subscriptionConfigFuture : null,
        () {
      super._subscriptionConfigFuture = value;
      __subscriptionConfigFutureIsInitialized = true;
    });
  }

  late final _$_productsFutureAtom =
      Atom(name: '_SubscriptionStore._productsFuture', context: context);

  ObservableFuture<List<PurchasableProduct>> get productsFuture {
    _$_productsFutureAtom.reportRead();
    return super._productsFuture;
  }

  @override
  ObservableFuture<List<PurchasableProduct>> get _productsFuture => productsFuture;

  bool __productsFutureIsInitialized = false;

  @override
  set _productsFuture(ObservableFuture<List<PurchasableProduct>> value) {
    _$_productsFutureAtom
        .reportWrite(value, __productsFutureIsInitialized ? super._productsFuture : null, () {
      super._productsFuture = value;
      __productsFutureIsInitialized = true;
    });
  }

  late final _$_otherSubscriberEmailFutureAtom =
      Atom(name: '_SubscriptionStore._otherSubscriberEmailFuture', context: context);

  ObservableFuture<String?> get otherSubscriberEmailFuture {
    _$_otherSubscriberEmailFutureAtom.reportRead();
    return super._otherSubscriberEmailFuture;
  }

  @override
  ObservableFuture<String?> get _otherSubscriberEmailFuture => otherSubscriberEmailFuture;

  bool __otherSubscriberEmailFutureIsInitialized = false;

  @override
  set _otherSubscriberEmailFuture(ObservableFuture<String?> value) {
    _$_otherSubscriberEmailFutureAtom.reportWrite(
        value, __otherSubscriberEmailFutureIsInitialized ? super._otherSubscriberEmailFuture : null,
        () {
      super._otherSubscriberEmailFuture = value;
      __otherSubscriberEmailFutureIsInitialized = true;
    });
  }

  late final _$_subscriptionStatusAtom =
      Atom(name: '_SubscriptionStore._subscriptionStatus', context: context);

  SubscriptionStatus? get subscriptionStatus {
    _$_subscriptionStatusAtom.reportRead();
    return super._subscriptionStatus;
  }

  @override
  SubscriptionStatus? get _subscriptionStatus => subscriptionStatus;

  @override
  set _subscriptionStatus(SubscriptionStatus? value) {
    _$_subscriptionStatusAtom.reportWrite(value, super._subscriptionStatus, () {
      super._subscriptionStatus = value;
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

  late final _$_fetchSubscriptionAsyncAction =
      AsyncAction('_SubscriptionStore._fetchSubscription', context: context);

  @override
  Future<Subscription> _fetchSubscription() {
    return _$_fetchSubscriptionAsyncAction.run(() => super._fetchSubscription());
  }

  late final _$refreshProductsAsyncAction =
      AsyncAction('_SubscriptionStore.refreshProducts', context: context);

  @override
  Future<List<PurchasableProduct>> refreshProducts() {
    return _$refreshProductsAsyncAction.run(() => super.refreshProducts());
  }

  late final _$refreshSubscriptionAsyncAction =
      AsyncAction('_SubscriptionStore.refreshSubscription', context: context);

  @override
  Future<Subscription> refreshSubscription() {
    return _$refreshSubscriptionAsyncAction.run(() => super.refreshSubscription());
  }

  late final _$refreshSubscriptionConfigAsyncAction =
      AsyncAction('_SubscriptionStore.refreshSubscriptionConfig', context: context);

  @override
  Future<api.SubscriptionConfigResponse?> refreshSubscriptionConfig() {
    return _$refreshSubscriptionConfigAsyncAction.run(() => super.refreshSubscriptionConfig());
  }

  late final _$refreshOtherSubscriberAsyncAction =
      AsyncAction('_SubscriptionStore.refreshOtherSubscriber', context: context);

  @override
  Future<String?> refreshOtherSubscriber() {
    return _$refreshOtherSubscriberAsyncAction.run(() => super.refreshOtherSubscriber());
  }

  late final _$refreshAllAsyncAction =
      AsyncAction('_SubscriptionStore.refreshAll', context: context);

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
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
  Future<void> verifyPurchase(
      {required String productId,
      required String price,
      required String currency,
      required int duration,
      required PurchaseDetails purchaseDetails}) {
    return _$verifyPurchaseAsyncAction.run(() => super.verifyPurchase(
        productId: productId,
        price: price,
        currency: currency,
        duration: duration,
        purchaseDetails: purchaseDetails));
  }

  late final _$retryVerificationProcessAsyncAction =
      AsyncAction('_SubscriptionStore.retryVerificationProcess', context: context);

  @override
  Future<void> retryVerificationProcess() {
    return _$retryVerificationProcessAsyncAction.run(() => super.retryVerificationProcess());
  }

  late final _$manageSubscriptionAsyncAction =
      AsyncAction('_SubscriptionStore.manageSubscription', context: context);

  @override
  Future<void> manageSubscription() {
    return _$manageSubscriptionAsyncAction.run(() => super.manageSubscription());
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
  void mockSubscriptionFailureStatus() {
    final _$actionInfo = _$_SubscriptionStoreActionController.startAction(
        name: '_SubscriptionStore.mockSubscriptionFailureStatus');
    try {
      return super.mockSubscriptionFailureStatus();
    } finally {
      _$_SubscriptionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
monthlyProduct: ${monthlyProduct},
highlightedProduct: ${highlightedProduct},
isSubscribed: ${isSubscribed},
isSubscriptionLoading: ${isSubscriptionLoading},
storeState: ${storeState}
    ''';
  }
}
