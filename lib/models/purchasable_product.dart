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
    required this.rawPrice,
    required this.currencySymbol,
    required this.currencyCode,
    required this.introductoryPrice,
  });

  final PlanDetails planDetails;
  final ProductDetails productDetails;
  final double rawPrice;
  final String currencySymbol;
  final String currencyCode;
  final double? introductoryPrice;

  @observable
  ProductStatus status;

  @computed
  String get id => planDetails.id;

  @computed
  bool get isDiscounted => introductoryPrice != null && introductoryPrice! > 0;

  @computed
  double get productPrice => isDiscounted ? introductoryPrice! : rawPrice;

  @computed
  int get duration => planDetails.id == kMonthlyPlan
      ? 1
      : planDetails.id == ksemiAnnualPlan
          ? 6
          : 12;

  @computed
  String get billedPerMonth => LocaleKeys.billedPerMonth.tr(
        namedArgs: {
          'amount': monthlyPrice,
          'period': planDetails.id == kMonthlyPlan
              ? LocaleKeys.monthly.tr()
              : planDetails.id == ksemiAnnualPlan
                  ? LocaleKeys.semiAnnual.tr()
                  : LocaleKeys.yearly.tr(),
        },
      );

  @computed
  String get billedPerMonthShort => LocaleKeys.billedInTotal.tr(
        namedArgs: {
          'amount': monthlyPrice,
          'period': planDetails.id == kMonthlyPlan
              ? LocaleKeys.monthly.tr()
              : planDetails.id == ksemiAnnualPlan
                  ? LocaleKeys.semiAnnual.tr()
                  : LocaleKeys.yearly.tr(),
        },
      );
  @computed
  String get monthlyPrice => productPrice.pricePerMonth(
        months: planDetails.id == kMonthlyPlan
            ? 1
            : planDetails.id == ksemiAnnualPlan
                ? 6
                : 12,
        currencySymbol: currencySymbol,
        currencyCode: currencyCode,
      );

  @computed
  bool get isPupular => planDetails.id == kPopularPlan;
  @computed
  String get billedInTotal => LocaleKeys.billedInTotal.tr(
        namedArgs: {
          'amount': productPrice.price(
            currencySymbol: currencySymbol,
            currencyCode: currencyCode,
          ),
          'period': planDetails.id == kMonthlyPlan
              ? LocaleKeys.month.tr()
              : planDetails.id == ksemiAnnualPlan
                  ? LocaleKeys.SixMonths.tr()
                  : LocaleKeys.year.tr(),
        },
      );
}

enum ProductStatus {
  purchasable,
  purchased,
  pending,
}
