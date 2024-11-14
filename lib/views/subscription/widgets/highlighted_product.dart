import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/number.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/views/subscription/widgets/billing_text.dart';
import 'package:mysterium_vpn/views/subscription/widgets/discount_tag.dart';
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
  Widget build(BuildContext context) => RippleWidget(
        onTap: selectProdcut,
        radius: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                EasyText(
                  product.id.tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: !isDarkTheme ? Palette.white : null,
                ),
                const SizedBox(width: 8),
                if (showDiscountTag)
                  DiscountTag(
                    monthlyRawPrice: monthlyRawPrice,
                    product: product,
                  ),
              ],
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                    ),
                children: [
                  TextSpan(
                    text: product.monthlyPrice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: LocaleKeys.perMonth.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.purple,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            if (isHighlighted && product.isDiscounted)
              _HighlighterText(
                monthlyRawPrice: monthlyRawPrice,
                product: product,
                isDarkTheme: isDarkTheme,
              )
            else
              BillingText(product: product, isDarkTheme: isDarkTheme),
            if (product.duration == 12 && isHighlighted && product.isDiscounted)
              EasyText(
                LocaleKeys.sixMonthsBonus.tr(),
                fontSize: 12,
                color: !isDarkTheme ? Palette.white : null,
              ),
          ],
        )
            .padding(horizontal: 16, vertical: 12)
            .card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(
                  color: Palette.purple,
                ),
              ),
              color: isDarkTheme ? const Color(0xff23222D) : const Color(0xff363355),
            )
            .width(double.infinity),
      );
}

class _HighlighterText extends StatelessWidget {
  const _HighlighterText({
    required this.monthlyRawPrice,
    required this.product,
    required this.isDarkTheme,
  });

  final double monthlyRawPrice;
  final PurchasableProduct product;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12,
                color: !isDarkTheme ? Palette.white : null,
              ),
          children: [
            TextSpan(
              text: LocaleKeys.currentPrice.tr(
                namedArgs: {
                  'amount': (monthlyRawPrice * product.duration).price(
                    currencySymbol: product.currencySymbol,
                    currencyCode: product.currencyCode,
                  ),
                },
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Palette.white,
                    color: !isDarkTheme ? Palette.white : null,
                    fontSize: 12,
                  ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 4),
            ),
            if (product.duration == 6)
              TextSpan(
                text: LocaleKeys.semiAnnualPlanDiscountPrice.tr(
                  namedArgs: {
                    'amount': product.productPrice.price(
                      currencySymbol: product.currencySymbol,
                      currencyCode: product.currencyCode,
                    ),
                  },
                ),
              )
            else
              TextSpan(
                text: LocaleKeys.yearlyPlanDiscountPrice.tr(
                  namedArgs: {
                    'amount': product.productPrice.price(
                      currencySymbol: product.currencySymbol,
                      currencyCode: product.currencyCode,
                    ),
                  },
                ),
              ),
          ],
        ),
      );
}
