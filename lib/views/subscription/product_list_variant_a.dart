import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/inherited/parent_scroll_controller.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
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
      controller: ParentScrollController.of(context),
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
    analyticsStore.logProductSelected(
      productId,
      productIds,
    );
  }
}
