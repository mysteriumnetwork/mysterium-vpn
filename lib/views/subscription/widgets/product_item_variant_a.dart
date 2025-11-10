import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_pricing.dart';
import 'package:styled_widget/styled_widget.dart';

class ProductItemVariantA extends StatelessWidget {
  const ProductItemVariantA({
    required this.productDetails,
    required this.onProductSelected,
    required this.selectedProductId,
    super.key,
  });

  final PurchasableProduct productDetails;
  final Function(String productId) onProductSelected;
  final String? selectedProductId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RippleWidget(
      radius: 20,
      onTap: () => onProductSelected(productDetails.id),
      child: Row(
        children: [
          SvgIcon(
            asset: Asset.icons.subscriptionItem,
          ).paddingDirectional(end: getMediaWidth(context) * 0.05),
          Expanded(
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(
                color: context.c.isDarkMode ? Palette.white : Palette.black,
              ),
              child: ProductPricing(product: productDetails),
            ),
          ),
          Observer(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (productDetails.status == ProductStatus.pending)
                  const LoadingIndicator(
                    radius: 18,
                  )
                else
                  _CheckMark(
                    isSelected: productDetails.id == selectedProductId,
                  ),
              ],
            ).padding(left: 14),
          ),
        ],
      ).padding(horizontal: 14, vertical: 8).decorated(
            border: Border.all(color: theme.hintColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  const _CheckMark({
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) => isSelected
      ? SvgIcon(asset: Asset.icons.checkmark)
      : CircleBox(
          color: Theme.of(context).secondaryHeaderColor,
          size: 20,
        );
}
