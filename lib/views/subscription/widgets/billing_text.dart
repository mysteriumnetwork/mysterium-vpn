import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/number.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';

class BillingText extends StatelessWidget {
  const BillingText({
    required this.product,
    required this.isDarkTheme,
    super.key,
  });

  final PurchasableProduct product;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) => EasyText(
        _getBillingText(),
        fontSize: 14,
        color: !isDarkTheme ? Palette.white : null,
      );

  String _getBillingText() => switch (product.duration) {
        12 => LocaleKeys.billedEveryYear.tr(
            namedArgs: {
              'amount': product.productPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
        6 => LocaleKeys.billedEvery6Months.tr(
            namedArgs: {
              'amount': product.productPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
        _ => LocaleKeys.billedEveryMonth.tr(
            namedArgs: {
              'amount': product.productPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
            },
          ),
      };
}
