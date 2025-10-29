import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/inherited/parent_scroll_controller.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_item_variant_d.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionProductsListVariantD extends ConsumerWidget {
  const SubscriptionProductsListVariantD({
    required this.products,
    required this.selectedProductId,
    super.key,
  });
  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProductId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);

    return ListView.builder(
      controller: ParentScrollController.of(context),
      clipBehavior: Clip.none,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      itemBuilder: (context, index) => ProductItemVariantD(
        product: products[index],
        onProductSelected: () {
          onProductSelected(
            products[index].id,
            analyticsStore,
            products.map((e) => e.id).toList(),
            selectedProductId,
          );
        },
        isDarkTheme: ref.read(themeStorePOD).isDarkMode,
        isSelected: selectedProductId.value == products[index].id,
        isPopular: products[index].id == products.first.id,
      ),
    ).height(120).padding(left: 20);
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
