import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/product_item.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

class SubscriptionProductsList extends StatelessWidget {
  const SubscriptionProductsList({
    required this.products,
    required this.originalPrice,
    super.key,
  });
  final List<PurchasableProduct> products;
  final double originalPrice;
  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: products.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => ProductItem(
          productDetails: products[index],
          originalPirce: originalPrice,
        ),
        separatorBuilder: (context, index) => SizedBox(height: getWindowHeight() * 0.02),
      );
}
