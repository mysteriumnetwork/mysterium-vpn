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
import 'package:styled_widget/styled_widget.dart';

class ProductItemVariantD extends StatelessWidget {
  const ProductItemVariantD({
    required this.product,
    required this.onProductSelected,
    required this.isSelected,
    required this.isDarkTheme,
    required this.isPopular,
    super.key,
  });

  final PurchasableProduct product;
  final VoidCallback onProductSelected;
  final bool isSelected;
  final bool isDarkTheme;
  final bool isPopular;
  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          if (isPopular)
            Positioned(
              top: -20,
              left: 15,
              child: EasyText(
                LocaleKeys.mostPopularTag.tr(),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Palette.white,
              ).padding(horizontal: 8, vertical: 4).decorated(
                    color: Palette.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
            ),
          if (isSelected)
            const Positioned(
              top: 10,
              right: 10,
              child: SvgIcon(
                asset: Assets.checkmark,
              ),
            ),
          RippleWidget(
            onTap: onProductSelected,
            radius: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  product.id.tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isSelected && !isDarkTheme ? Palette.white : null,
                ),
                const SizedBox(width: 8),
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
                EasyText(
                  _getBillingText(),
                  fontSize: 12,
                  color: isSelected && !isDarkTheme ? Palette.white : null,
                ),
              ],
            ).padding(horizontal: 16, vertical: 12).width(260),
          ),
        ],
      )
          .card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(
                color: Palette.purple,
              ),
            ),
            color: isSelected
                ? isDarkTheme
                    ? const Color(0xff23222D)
                    : const Color(0xff363355)
                : isDarkTheme
                    ? const Color(0x6623222d)
                    : const Color(0xffF5F3FD),
          )
          .paddingDirectional(end: 10);

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
}
