// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_limited_time_offer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionLimitedTimeOfferStore on _SubscriptionLimitedTimeOfferStore, Store {
  Computed<int>? _$discountPercentComputed;

  @override
  int get discountPercent =>
      (_$discountPercentComputed ??= Computed<int>(() => super.discountPercent,
              name: '_SubscriptionLimitedTimeOfferStore.discountPercent'))
          .value;

  late final _$_futureAtom =
      Atom(name: '_SubscriptionLimitedTimeOfferStore._future', context: context);

  ObservableFuture<({DateTime expiryDate, ProductOffer offer, PurchasableProduct product})?>
      get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<({DateTime expiryDate, ProductOffer offer, PurchasableProduct product})?>
      get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(
      ObservableFuture<({DateTime expiryDate, ProductOffer offer, PurchasableProduct product})?>
          value) {
    _$_futureAtom.reportWrite(value, __futureIsInitialized ? super._future : null, () {
      super._future = value;
      __futureIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
discountPercent: ${discountPercent}
    ''';
  }
}
