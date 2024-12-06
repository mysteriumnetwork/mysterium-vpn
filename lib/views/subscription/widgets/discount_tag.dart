import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

class DiscountTag extends HookWidget {
  const DiscountTag({
    required this.monthlyRawPrice,
    required this.product,
    super.key,
  });
  final double monthlyRawPrice;
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) {
    final discount = useMemoized(
      () {
        final fullAmount = monthlyRawPrice * product.duration;
        final amount = product.productPrice;

        return ((fullAmount - amount) / fullAmount * 100).round();
      },
      [product.rawPrice, product.duration, monthlyRawPrice],
    );

    if (!product.isDiscounted(monthlyRawPrice)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFF735F),
            Color(0xffFF40CA),
          ],
        ),
      ),
      child: EasyText(
        LocaleKeys.discountTag.tr(namedArgs: {'discount': '$discount%'}),
        fontSize: 12,
        color: Palette.white,
      ),
    );
  }
}
