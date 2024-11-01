import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/product_item.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

class SubscriptionProductsList extends ConsumerWidget {
  const SubscriptionProductsList({
    required this.products,
    super.key,
  });
  final List<PurchasableProduct> products;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsStore = ref.watch(subscriptionStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => ProductItem(
        productDetails: products[index],
        onProductSelected: (productId) {
          onProductSelected(
            productId,
            analyticsStore,
            subsStore,
            products.map((e) => e.id).toList(),
          );
        },
        selectedProductId: subsStore.selectedProductId,
        purchasedProductId: subsStore.purchasedProductId,
        isSusbActive: subsStore.subscription?.active ?? false,
      ),
      separatorBuilder: (context, index) => SizedBox(height: getWindowHeight() * 0.02),
    );
  }

  void onProductSelected(
    String productId,
    AnalyticsStore analyticsStore,
    SubscriptionStore subsStore,
    List<String> productIds,
  ) {
    subsStore.selectedProductId = productId;
    AnalyticsEvent? event;
    if (productId == kAnnualPlan) {
      event = AnalyticsEvent.select12;
    } else if (productId == kMonthlyPlan) {
      event = AnalyticsEvent.select1;
    } else if (productId == ksemiAnnualPlan) {
      event = AnalyticsEvent.select6;
    }
    if (event != null) {
      analyticsStore.logEvent(
        event,
        parameters: {
          'item_ids': productIds,
        },
      );
    }
  }
}
