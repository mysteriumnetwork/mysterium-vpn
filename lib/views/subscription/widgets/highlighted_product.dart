import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/number.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
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
    this.isSelected = false,
    super.key,
  });
  final PurchasableProduct product;
  final double monthlyRawPrice;
  final bool isDarkTheme;
  final VoidCallback? selectProdcut;
  final bool showDiscountTag;
  final bool isHighlighted;
  final bool isSelected;

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
                ),
                const SizedBox(width: 8),
                if (showDiscountTag)
                  DiscountTag(
                    discountLabel: product.duration == 12
                        ? LocaleKeys.discountTag.tr(
                            namedArgs: {
                              'discount': '49%',
                            },
                          )
                        : LocaleKeys.discountTag.tr(
                            namedArgs: {
                              'discount': '${_calculateDiscountPercentage()}%',
                            },
                          ),
                  ),
                if (isSelected) ...[
                  const Spacer(),
                  const SvgIcon(
                    asset: Assets.checkmark,
                  ),
                ],
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
            if (isHighlighted)
              _HighlighterText(monthlyRawPrice: monthlyRawPrice, product: product)
            else
              EasyText(
                _getBillingText(),
                fontSize: 14,
              ),
            if (product.duration == 12 && isHighlighted)
              EasyText(
                LocaleKeys.sixMonthsBonus.tr(),
                fontSize: 12,
              ),
          ],
        )
            .padding(horizontal: 16, vertical: 12)
            .card(
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

  String _getBillingText() => switch (product.duration) {
        12 => LocaleKeys.billedEveryYear.tr(
            namedArgs: {
              'amount': product.rawPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
        6 => LocaleKeys.billedEvery6Months.tr(
            namedArgs: {
              'amount': product.rawPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
        _ => LocaleKeys.billedEveryMonth.tr(
            namedArgs: {
              'amount': product.rawPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
      };

  int _calculateDiscountPercentage() => (((monthlyRawPrice * product.duration) - product.rawPrice) /
          (monthlyRawPrice * product.duration) *
          100)
      .round();
}

class _HighlighterText extends StatelessWidget {
  const _HighlighterText({
    required this.monthlyRawPrice,
    required this.product,
  });

  final double monthlyRawPrice;
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12,
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
                    'amount': product.rawPrice.price(
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
                    'amount': product.rawPrice.price(
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
