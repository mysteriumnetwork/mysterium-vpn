import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_pricing.dart';
import 'package:styled_widget/styled_widget.dart';

class HighlightedProduct extends StatelessWidget {
  const HighlightedProduct({
    required this.product,
    required this.isDarkTheme,
    required this.monthlyRawPrice,
    required this.showDiscountTag,
    required this.isHighlighted,
    this.selectProdcut,
    super.key,
  });
  final PurchasableProduct product;
  final double monthlyRawPrice;
  final bool isDarkTheme;
  final VoidCallback? selectProdcut;
  final bool showDiscountTag;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RippleWidget(
      onTap: selectProdcut,
      radius: 15,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(color: Palette.white),
        child: ProductPricing(
          product: product,
          monthlyPrice: monthlyRawPrice,
          showDiscount: showDiscountTag,
        ).padding(horizontal: 16, vertical: 12).width(double.infinity),
      ).card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: Palette.purple,
          ),
        ),
        color: isDarkTheme ? const Color(0xff23222D) : const Color(0xff363355),
      ),
    );
  }
}
