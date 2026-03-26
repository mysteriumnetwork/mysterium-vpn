// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_purchase_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionPurchaseStore on _SubscriptionPurchaseStore, Store {
  late final _$_lastPurchaseAtom = Atom(
    name: '_SubscriptionPurchaseStore._lastPurchase',
    context: context,
  );

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

  late final _$_futureAtom = Atom(name: '_SubscriptionPurchaseStore._future', context: context);

  ObservableFuture<void> get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<void> get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(ObservableFuture<void> value) {
    _$_futureAtom.reportWrite(value, __futureIsInitialized ? super._future : null, () {
      super._future = value;
      __futureIsInitialized = true;
    });
  }

  late final _$_subscriptionStatusAtom = Atom(
    name: '_SubscriptionPurchaseStore._subscriptionStatus',
    context: context,
  );

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

  late final _$_subscriptionErrorAtom = Atom(
    name: '_SubscriptionPurchaseStore._subscriptionError',
    context: context,
  );

  Object? get subscriptionError {
    _$_subscriptionErrorAtom.reportRead();
    return super._subscriptionError;
  }

  @override
  Object? get _subscriptionError => subscriptionError;

  @override
  set _subscriptionError(Object? value) {
    _$_subscriptionErrorAtom.reportWrite(value, super._subscriptionError, () {
      super._subscriptionError = value;
    });
  }

  late final _$subscribeToPackageAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore.subscribeToPackage',
    context: context,
  );

  @override
  Future<void> subscribeToPackage({required ProductDetails product}) {
    return _$subscribeToPackageAsyncAction.run(() => super.subscribeToPackage(product: product));
  }

  late final _$redeemCodeAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore.redeemCode',
    context: context,
  );

  @override
  Future<void> redeemCode() {
    return _$redeemCodeAsyncAction.run(() => super.redeemCode());
  }

  late final _$retryVerificationProcessAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore.retryVerificationProcess',
    context: context,
  );

  @override
  Future<void> retryVerificationProcess() {
    return _$retryVerificationProcessAsyncAction.run(() => super.retryVerificationProcess());
  }

  late final _$manageSubscriptionAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore.manageSubscription',
    context: context,
  );

  @override
  Future<void> manageSubscription() {
    return _$manageSubscriptionAsyncAction.run(() => super.manageSubscription());
  }

  late final _$_onPurchaseUpdateAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore._onPurchaseUpdate',
    context: context,
  );

  @override
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    return _$_onPurchaseUpdateAsyncAction.run(() => super._onPurchaseUpdate(purchaseDetailsList));
  }

  late final _$_handlePurchaseAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore._handlePurchase',
    context: context,
  );

  @override
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) {
    return _$_handlePurchaseAsyncAction.run(() => super._handlePurchase(purchaseDetails));
  }

  late final _$_verifyPurchaseAsyncAction = AsyncAction(
    '_SubscriptionPurchaseStore._verifyPurchase',
    context: context,
  );

  @override
  Future<void> _verifyPurchase({
    required String productId,
    required String price,
    required String currency,
    required int duration,
    required PurchaseDetails purchaseDetails,
  }) {
    return _$_verifyPurchaseAsyncAction.run(
      () => super._verifyPurchase(
        productId: productId,
        price: price,
        currency: currency,
        duration: duration,
        purchaseDetails: purchaseDetails,
      ),
    );
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
