import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

PlanData usePlanData(PurchasableProduct product, {PurchasableProduct? otherProduct}) {
  final store = useProvider(subscriptionPlansStorePOD);

  return useComputedValue(
    () {
      final isBestValue = store.bestValueProducts.any((it) => it.id == product.id);
      final config = store.findConfig(product);
      final period = switch (product.duration) {
        1 => LocaleKeys.month.tr(),
        12 => LocaleKeys.year.tr(),
        _ => '',
      };

      final discount = otherProduct != null ? otherProduct.periodDiscountPercentage(product) : 0;

      return PlanData(
        name: config.name.tr(),
        price: product.moneyMonthly.toString(),
        period: LocaleKeys.month.tr(),
        billingInfo: LocaleKeys.subscriptionPlanBillingInfo.tr(
          namedArgs: {
            'amount': product.money.toString(),
            'period': period,
          },
        ),
        bestValueBadge: isBestValue ? LocaleKeys.subscriptionPlanBestValue.tr() : null,
        oldPrice: discount > 0 ? otherProduct!.money.toString() : null,
        promoBadge: discount > 0
            ? LocaleKeys.subscriptionPlanSavePercent.tr(args: [discount.toString()])
            : null,
      );
    },
    [store, product, otherProduct],
  );
}
