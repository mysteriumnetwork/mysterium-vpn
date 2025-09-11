import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_pricing.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
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
          Positioned(
            top: 10,
            right: 10,
            child: SvgIcon(asset: Asset.icons.checkmark),
          ),
        RippleWidget(
          onTap: onProductSelected,
          radius: 15,
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: switch (theme.brightness) {
                Brightness.dark => Palette.white,
                Brightness.light => isSelected ? Palette.white : Palette.black,
              },
            ),
            child: Center(
              child: ProductPricing(
                product: product,
              ).padding(horizontal: 16, vertical: 2).width(260),
            ),
          ),
        ),
      ],
    )
        .card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Palette.purple),
          ),
          color: switch (theme.brightness) {
            Brightness.dark => isSelected ? const Color(0xff23222D) : const Color(0xff353355),
            Brightness.light => isSelected ? const Color(0xFF353355) : const Color(0xFFF5F3FD),
          },
        )
        .paddingDirectional(end: 10);
  }
}
