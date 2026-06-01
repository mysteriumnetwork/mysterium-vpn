// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plans_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionPlansStore on _SubscriptionPlansStore, Store {
  Computed<PurchasableProduct?>? _$purchasedProductComputed;

  @override
  PurchasableProduct? get purchasedProduct =>
      (_$purchasedProductComputed ??= Computed<PurchasableProduct?>(
        () => super.purchasedProduct,
        name: '_SubscriptionPlansStore.purchasedProduct',
      )).value;
  Computed<List<PurchasableProduct>>? _$productsComputed;

  @override
  List<PurchasableProduct> get products =>
      (_$productsComputed ??= Computed<List<PurchasableProduct>>(
        () => super.products,
        name: '_SubscriptionPlansStore.products',
      )).value;
  Computed<List<PurchasableProduct>>? _$monthlyProductsComputed;

  @override
  List<PurchasableProduct> get monthlyProducts =>
      (_$monthlyProductsComputed ??= Computed<List<PurchasableProduct>>(
        () => super.monthlyProducts,
        name: '_SubscriptionPlansStore.monthlyProducts',
      )).value;
  Computed<List<PurchasableProduct>>? _$annualProductsComputed;

  @override
  List<PurchasableProduct> get annualProducts =>
      (_$annualProductsComputed ??= Computed<List<PurchasableProduct>>(
        () => super.annualProducts,
        name: '_SubscriptionPlansStore.annualProducts',
      )).value;
  Computed<List<PurchasableProduct>>? _$bestValueProductsComputed;

  @override
  List<PurchasableProduct> get bestValueProducts =>
      (_$bestValueProductsComputed ??= Computed<List<PurchasableProduct>>(
        () => super.bestValueProducts,
        name: '_SubscriptionPlansStore.bestValueProducts',
      )).value;

  late final _$_futureAtom = Atom(
    name: '_SubscriptionPlansStore._future',
    context: context,
  );

  ObservableFuture<List<PurchasableProduct>> get future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  ObservableFuture<List<PurchasableProduct>> get _future => future;

  bool __futureIsInitialized = false;

  @override
  set _future(ObservableFuture<List<PurchasableProduct>> value) {
    _$_futureAtom.reportWrite(
      value,
      __futureIsInitialized ? super._future : null,
      () {
        super._future = value;
        __futureIsInitialized = true;
      },
    );
  }

  late final _$_SubscriptionPlansStoreActionController = ActionController(
    name: '_SubscriptionPlansStore',
    context: context,
  );

  @override
  SubscriptionPlanFeatures findConfig(PurchasableProduct product) {
    final _$actionInfo = _$_SubscriptionPlansStoreActionController.startAction(
      name: '_SubscriptionPlansStore.findConfig',
    );
    try {
      return super.findConfig(product);
    } finally {
      _$_SubscriptionPlansStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
purchasedProduct: ${purchasedProduct},
products: ${products},
monthlyProducts: ${monthlyProducts},
annualProducts: ${annualProducts},
bestValueProducts: ${bestValueProducts}
    ''';
  }
}
