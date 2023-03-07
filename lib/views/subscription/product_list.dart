import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/product_item.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

class SubscriptionProductsList extends StatelessWidget {
  const SubscriptionProductsList({
    required this.products,
    required this.selectedProduct,
    super.key,
  });
  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProduct;
  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: products.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => ProductItem(
          productDetails: products[index],
          selectedProduct: selectedProduct,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      );
}
