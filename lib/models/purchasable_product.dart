import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/plan_details.dart';

part 'purchasable_product.g.dart';

// ignore: library_private_types_in_public_api
class PurchasableProduct = _PurchasableProduct with _$PurchasableProduct;

abstract class _PurchasableProduct with Store {
  _PurchasableProduct({
    required this.planDetails,
    required this.productDetails,
    required this.status,
  });

  final PlanDetails planDetails;
  final ProductDetails productDetails;
  @observable
  ProductStatus status;

  @computed
  String get id => planDetails.id;

  @computed
  String get monthlyPrice => planDetails.id == kMonthlyPlan
      ? productDetails.rawPrice.price(
          currencySymbol: productDetails.currencySymbol,
          currencyCode: productDetails.currencyCode,
        )
      : planDetails.id == kAnnualPlan
          ? productDetails.rawPrice.pricePerMonth(
              months: 12,
              currencySymbol: productDetails.currencySymbol,
              currencyCode: productDetails.currencyCode,
            )
          : productDetails.rawPrice.pricePerMonth(
              months: 6,
              currencySymbol: productDetails.currencySymbol,
              currencyCode: productDetails.currencyCode,
            );
  @computed
  bool get isPupular => planDetails.id == kPopularPlan;
  @computed
  String get billedInTotal => LocaleKeys.billedInTotal.tr(
        namedArgs: {
          'amount': productDetails.rawPrice.price(
            currencySymbol: productDetails.currencySymbol,
            currencyCode: productDetails.currencyCode,
          ),
          'period': planDetails.id == kMonthlyPlan
              ? LocaleKeys.monthly.tr()
              : planDetails.id == ksemiAnnualPlan
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
