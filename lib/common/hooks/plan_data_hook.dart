import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

PlanData usePlanData({
  required PurchasableProduct product,
  required bool isOffer,
  PurchasableProduct? otherProduct,
}) {
  final store = useProvider(subscriptionPlansStorePOD);
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);

  return useComputedValue(
    () {
      final currentPlanGateway = subscriptionStore.subscriptionFuture.value?.gateway;
      final useStorePrices = currentPlanGateway == null ||
          currentPlanGateway.isEmpty ||
          isMobilePaymentGateway(currentPlanGateway);
      final canUseSalesValues = remoteConfigStore.pricingMonthly;
      final isBestValue = store.bestValueProducts.any((it) => it.id == product.id);
      final config = store.findConfig(product);
      final period = switch (product.duration) {
        1 => LocaleKeys.month.tr(),
        12 => LocaleKeys.year.tr(),
        _ => '',
      };

      final discount = otherProduct != null
          ? useStorePrices
              ? otherProduct.periodDiscountPercentage(product)
              : otherProduct.periodDiscountPercentage(product)
          : 0;
      final price = useStorePrices ? product.moneyMonthly : product.moneyMonthlyBackend;
      final money = useStorePrices ? product.money : product.backendMoney;
      final oldPrice = otherProduct != null
          ? useStorePrices
              ? otherProduct.moneyMonthly
              : otherProduct.backendMoney
          : null;

      return PlanData(
        period: period,
        fullPriceLabel: LocaleKeys.fullPriceLabel.tr(),
        discountedLabel: LocaleKeys.discountedPriceLabel.tr(),
        isOffer: isOffer,
        name: config.name.tr(),
        monthlyFullPrice: canUseSalesValues ? oldPrice?.toString() : null,
        monthlyDiscountedPrice: canUseSalesValues ? price.toString() : null,
        fullPrice: '$money',
        bestValueBadge: isBestValue ? LocaleKeys.subscriptionPlanBestValue.tr() : null,
        promoBadge: discount > 0 && canUseSalesValues
            ? isOffer
                ? LocaleKeys.subscriptionPlanSaveWith.tr(
                    namedArgs: {'percent': discount.toString(), 'planId': '1-${period.tr()}'},
                  )
                : LocaleKeys.subscriptionPlanSavePercent.tr(args: [discount.toString()])
            : null,
        icon: isOffer ? null : UntitledUI.stars_02,
        perMonth: LocaleKeys.perMonth.tr(),
        periodLabel: period.tr(),
      );
    },
    [store, product, otherProduct],
  );
}
