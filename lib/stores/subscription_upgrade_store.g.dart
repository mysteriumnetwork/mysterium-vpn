// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_upgrade_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionUpgradeStore on _SubscriptionUpgradeStore, Store {
  Computed<List<PurchasableProduct>>? _$purchasableProductsComputed;

  @override
  List<PurchasableProduct> get purchasableProducts => (_$purchasableProductsComputed ??=
          Computed<List<PurchasableProduct>>(() => super.purchasableProducts,
              name: '_SubscriptionUpgradeStore.purchasableProducts'))
      .value;
  Computed<PurchasableProduct?>? _$downgradeProductComputed;

  @override
  PurchasableProduct? get downgradeProduct =>
      (_$downgradeProductComputed ??= Computed<PurchasableProduct?>(() => super.downgradeProduct,
              name: '_SubscriptionUpgradeStore.downgradeProduct'))
          .value;
  Computed<PurchasableProduct?>? _$upgradeProductComputed;

  @override
  PurchasableProduct? get upgradeProduct =>
      (_$upgradeProductComputed ??= Computed<PurchasableProduct?>(() => super.upgradeProduct,
              name: '_SubscriptionUpgradeStore.upgradeProduct'))
          .value;
  Computed<int?>? _$upgradeDiscountPercentComputed;

  @override
  int? get upgradeDiscountPercent =>
      (_$upgradeDiscountPercentComputed ??= Computed<int?>(() => super.upgradeDiscountPercent,
              name: '_SubscriptionUpgradeStore.upgradeDiscountPercent'))
          .value;

  late final _$upgradeAsyncAction =
      AsyncAction('_SubscriptionUpgradeStore.upgrade', context: context);

  @override
  Future<void> upgrade() {
    return _$upgradeAsyncAction.run(() => super.upgrade());
  }

  @override
  String toString() {
    return '''
purchasableProducts: ${purchasableProducts},
downgradeProduct: ${downgradeProduct},
upgradeProduct: ${upgradeProduct},
upgradeDiscountPercent: ${upgradeDiscountPercent}
    ''';
  }
}
