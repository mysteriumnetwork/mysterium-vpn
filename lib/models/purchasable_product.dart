import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

part 'purchasable_product.g.dart';

// ignore: library_private_types_in_public_api
class PurchasableProduct = _PurchasableProduct with _$PurchasableProduct;

abstract class _PurchasableProduct with Store {
  _PurchasableProduct({required this.productDetails, required this.status});

  final ProductDetails productDetails;

  @observable
  ProductStatus status;

  @computed
  String get id => productDetails.id;
  @computed
  String get title => productDetails.title;
  @computed
  String get description => productDetails.description;
  @computed
  String get fullPrice => productDetails.price;
  @computed
  String get originalMonthlyPrice => productDetails.id != kMonthlyPlan ? r'$9.99  ' : '';
  @computed
  String get monthlyPrice => productDetails.id == kMonthlyPlan
      ? r'$9.99'
      : productDetails.id == kAnnualPlan
          ? r'$4.99'
          : r'$6.99';
  @computed
  bool get isPupular => productDetails.id == kPopularPlan;
  @computed
  String get billedInTotal => LocaleKeys.billedInTotal.tr(
        namedArgs: {
          'amount': fullPrice,
          'period': productDetails.id == kMonthlyPlan
              ? LocaleKeys.monthly.tr()
              : productDetails.id == ksemiAnnualPlan
                  ? LocaleKeys.semiAnnual.tr()
                  : LocaleKeys.yearly.tr(),
        },
      );
}

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}
