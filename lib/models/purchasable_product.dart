import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/plan_details.dart';

part 'purchasable_product.g.dart';

// ignore: library_private_types_in_public_api
class PurchasableProduct = _PurchasableProduct with _$PurchasableProduct;

abstract class _PurchasableProduct with Store {
  _PurchasableProduct({required this.productDetails, required this.status});

  final PlanDetails productDetails;

  @observable
  ProductStatus status;

  @computed
  String get id => productDetails.id.replaceAll('-', '_');
  @computed
  String get fullPrice => '\$${productDetails.price.usd.toStringAsFixed(2)}';
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
