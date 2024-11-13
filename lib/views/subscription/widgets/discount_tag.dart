import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

class DiscountTag extends StatelessWidget {
  const DiscountTag({
    required this.monthlyRawPrice,
    required this.product,
    super.key,
  });
  final double monthlyRawPrice;
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) => product.isDiscounted
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xffFF735F),
                Color(0xffFF40CA),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: EasyText(
            LocaleKeys.discountTag.tr(
              namedArgs: {
                'discount': '${_calculateDiscountPercentage()}%',
              },
            ),
            fontSize: 12,
          ),
        )
      : const SizedBox.shrink();

  int _calculateDiscountPercentage() =>
      (((monthlyRawPrice * product.duration) - product.productPrice) /
              (monthlyRawPrice * product.duration) *
              100)
          .round();
}
