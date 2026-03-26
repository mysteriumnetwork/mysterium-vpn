// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchasable_product.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PurchasableProduct on _PurchasableProduct, Store {
  Computed<String>? _$idComputed;

  @override
  String get id =>
      (_$idComputed ??= Computed<String>(() => super.id, name: '_PurchasableProduct.id')).value;
  Computed<Money>? _$moneyMonthlyComputed;

  @override
  Money get moneyMonthly => (_$moneyMonthlyComputed ??= Computed<Money>(
    () => super.moneyMonthly,
    name: '_PurchasableProduct.moneyMonthly',
  )).value;
  Computed<Money>? _$moneyMonthlyBackendComputed;

  @override
  Money get moneyMonthlyBackend => (_$moneyMonthlyBackendComputed ??= Computed<Money>(
    () => super.moneyMonthlyBackend,
    name: '_PurchasableProduct.moneyMonthlyBackend',
  )).value;
  Computed<Money>? _$moneyAnnualBackendComputed;

  @override
  Money get moneyAnnualBackend => (_$moneyAnnualBackendComputed ??= Computed<Money>(
    () => super.moneyAnnualBackend,
    name: '_PurchasableProduct.moneyAnnualBackend',
  )).value;
  Computed<Money>? _$moneyAnnualComputed;

  @override
  Money get moneyAnnual => (_$moneyAnnualComputed ??= Computed<Money>(
    () => super.moneyAnnual,
    name: '_PurchasableProduct.moneyAnnual',
  )).value;
  Computed<Money>? _$moneyComputed;

  @override
  Money get money => (_$moneyComputed ??= Computed<Money>(
    () => super.money,
    name: '_PurchasableProduct.money',
  )).value;
  Computed<Money>? _$backendMoneyComputed;

  @override
  Money get backendMoney => (_$backendMoneyComputed ??= Computed<Money>(
    () => super.backendMoney,
    name: '_PurchasableProduct.backendMoney',
  )).value;
  Computed<int>? _$introductoryDiscountPercentageComputed;

  @override
  int get introductoryDiscountPercentage =>
      (_$introductoryDiscountPercentageComputed ??= Computed<int>(
        () => super.introductoryDiscountPercentage,
        name: '_PurchasableProduct.introductoryDiscountPercentage',
      )).value;
  Computed<double>? _$productPriceComputed;

  @override
  double get productPrice => (_$productPriceComputed ??= Computed<double>(
    () => super.productPrice,
    name: '_PurchasableProduct.productPrice',
  )).value;
  Computed<int>? _$durationComputed;

  @override
  int get duration => (_$durationComputed ??= Computed<int>(
    () => super.duration,
    name: '_PurchasableProduct.duration',
  )).value;
  Computed<String>? _$billedPerMonthComputed;

  @override
  String get billedPerMonth => (_$billedPerMonthComputed ??= Computed<String>(
    () => super.billedPerMonth,
    name: '_PurchasableProduct.billedPerMonth',
  )).value;
  Computed<String>? _$billedPerMonthShortComputed;

  @override
  String get billedPerMonthShort => (_$billedPerMonthShortComputed ??= Computed<String>(
    () => super.billedPerMonthShort,
    name: '_PurchasableProduct.billedPerMonthShort',
  )).value;
  Computed<double>? _$monthlyValueComputed;

  @override
  double get monthlyValue => (_$monthlyValueComputed ??= Computed<double>(
    () => super.monthlyValue,
    name: '_PurchasableProduct.monthlyValue',
  )).value;
  Computed<String>? _$monthlyPriceComputed;

  @override
  String get monthlyPrice => (_$monthlyPriceComputed ??= Computed<String>(
    () => super.monthlyPrice,
    name: '_PurchasableProduct.monthlyPrice',
  )).value;
  Computed<String>? _$annualPriceComputed;

  @override
  String get annualPrice => (_$annualPriceComputed ??= Computed<String>(
    () => super.annualPrice,
    name: '_PurchasableProduct.annualPrice',
  )).value;
  Computed<bool>? _$isPupularComputed;

  @override
  bool get isPupular => (_$isPupularComputed ??= Computed<bool>(
    () => super.isPupular,
    name: '_PurchasableProduct.isPupular',
  )).value;
  Computed<String>? _$billedInTotalComputed;

  @override
  String get billedInTotal => (_$billedInTotalComputed ??= Computed<String>(
    () => super.billedInTotal,
    name: '_PurchasableProduct.billedInTotal',
  )).value;

  late final _$statusAtom = Atom(name: '_PurchasableProduct.status', context: context);

  @override
  ProductStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ProductStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$_PurchasableProductActionController = ActionController(
    name: '_PurchasableProduct',
    context: context,
  );

  @override
  int periodDiscountPercentage(PurchasableProduct otherProduct) {
    final _$actionInfo = _$_PurchasableProductActionController.startAction(
      name: '_PurchasableProduct.periodDiscountPercentage',
    );
    try {
      return super.periodDiscountPercentage(otherProduct);
    } finally {
      _$_PurchasableProductActionController.endAction(_$actionInfo);
    }
  }

  @override
  int discountPercentageBackend(PurchasableProduct otherProduct) {
    final _$actionInfo = _$_PurchasableProductActionController.startAction(
      name: '_PurchasableProduct.discountPercentageBackend',
    );
    try {
      return super.discountPercentageBackend(otherProduct);
    } finally {
      _$_PurchasableProductActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
id: ${id},
moneyMonthly: ${moneyMonthly},
moneyMonthlyBackend: ${moneyMonthlyBackend},
moneyAnnualBackend: ${moneyAnnualBackend},
moneyAnnual: ${moneyAnnual},
money: ${money},
backendMoney: ${backendMoney},
introductoryDiscountPercentage: ${introductoryDiscountPercentage},
productPrice: ${productPrice},
duration: ${duration},
billedPerMonth: ${billedPerMonth},
billedPerMonthShort: ${billedPerMonthShort},
monthlyValue: ${monthlyValue},
monthlyPrice: ${monthlyPrice},
annualPrice: ${annualPrice},
isPupular: ${isPupular},
billedInTotal: ${billedInTotal}
    ''';
  }
}
