import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

PlanData usePlanData({
  required PurchasableProduct product,
  required bool isOffer,
  PurchasableProduct? otherProduct,
}) {
  final store = useProvider<SubscriptionPlansStore>(subscriptionPlansStorePOD);
  final remoteConfigStore = useProvider<RemoteConfigStore>(remoteConfigStorePOD);
  final subscriptionStore = useProvider<SubscriptionStore>(subscriptionStorePOD);

  return useComputedValue(() {
    final currentPlanGateway = subscriptionStore.subscriptionFuture.value?.gateway;
    final useStorePrices =
        currentPlanGateway == null ||
        currentPlanGateway.isEmpty ||
        isMobilePaymentGateway(currentPlanGateway);
    final canUseSalesValues = remoteConfigStore.pricingMonthly;
    final isBestValue = store.bestValueProducts.any((it) => it.id == product.id);
    final isBasic = product.id.contains('basic');
    final config = store.findConfig(product);
    final periodLabel = switch (product.duration) {
      1 => S.current.month,
      12 => S.current.year,
      _ => '',
    };

    final discount = otherProduct != null
        ? useStorePrices
              ? otherProduct.periodDiscountPercentage(product)
              : otherProduct.discountPercentageBackend(product)
        : 0;
    final price = useStorePrices ? product.moneyMonthly : product.moneyMonthlyBackend;
    final money = useStorePrices ? product.money : product.backendMoney;
    final oldPrice = otherProduct != null
        ? useStorePrices
              ? otherProduct.moneyMonthly
              : otherProduct.moneyMonthlyBackend
        : null;

    return PlanData(
      fullPriceLabel: S.current.fullPriceLabel,
      discountedLabel: S.current.discountedPriceLabel,
      isOffer: isOffer,
      name: Tr.byKeyOrNull(config.name) ?? config.name,
      monthlyFullPrice: canUseSalesValues ? oldPrice?.toString() : null,
      monthlyDiscountedPrice: canUseSalesValues ? price.toString() : null,
      fullPrice: '$money',
      bestValueBadge: isBestValue ? S.current.subscriptionPlanBestValue : null,
      promoBadge: discount > 0 && canUseSalesValues
          ? isOffer
                ? S.current.subscriptionPlanSaveWith(discount.toString(), '1-$periodLabel')
                : S.current.subscriptionPlanSavePercent(discount.toString())
          : null,
      icon: isOffer
          ? null
          : isBasic
          ? UntitledUI.star_04
          : UntitledUI.stars_02,
      perMonth: S.current.perMonth,
      periodLabel: periodLabel,
    );
  }, [store, product, otherProduct]);
}
