import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/product_item.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

class SubscriptionProductsList extends StatelessWidget {
  const SubscriptionProductsList({
    required this.products,
    required this.selectedProduct,
    required this.originalPrice,
    super.key,
  });
  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProduct;
  final double originalPrice;
  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: products.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => ProductItem(
          productDetails: products[index],
          selectedProduct: selectedProduct,
          originalPirce: originalPrice,
        ),
        separatorBuilder: (context, index) => SizedBox(height: getWindowHeight() * 0.02),
      );
}
