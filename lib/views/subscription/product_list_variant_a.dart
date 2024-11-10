import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_item_variant_a.dart';

class SubscriptionProductsListVariantA extends ConsumerWidget {
  const SubscriptionProductsListVariantA({
    required this.products,
    required this.selectedProductId,
    super.key,
  });
  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProductId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => ProductItemVariantA(
        productDetails: products[index],
        onProductSelected: (productId) {
          onProductSelected(
            productId,
            analyticsStore,
            products.map((e) => e.id).toList(),
            selectedProductId,
          );
        },
        selectedProductId: selectedProductId.value,
      ),
      separatorBuilder: (context, index) => SizedBox(height: getWindowHeight() * 0.02),
    );
  }

  void onProductSelected(
    String productId,
    AnalyticsStore analyticsStore,
    List<String> productIds,
    ValueNotifier<String> selectedProductId,
  ) {
    selectedProductId.value = productId;
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
