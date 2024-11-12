import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
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
  final String selectedProductId;
  @override
  Widget build(BuildContext context) => RippleWidget(
        radius: 20,
        onTap: () => onProductSelected(productDetails.id),
        child: Row(
          children: [
            const SvgIcon(
              asset: Assets.subscriptionItem,
            ).paddingDirectional(end: getMediaWidth(context) * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  productDetails.id.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                Row(
                  children: [
                    EasyText(
                      productDetails.billedInTotal,
                      color: Palette.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ).fittedBox(),
                EasyText(
                  productDetails.billedPerMonth,
                  fontSize: 14,
                ),
              ],
            ).expanded(),
            Observer(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (productDetails.status == ProductStatus.pending)
                    const LoadingIndicator(
                      radius: 18,
                      strokeWidth: 1.5,
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
              border: Border.all(color: Theme.of(context).hintColor),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
      );
}

class _CheckMark extends StatelessWidget {
  const _CheckMark({
    required this.isSelected,
  });

  final bool isSelected;
  @override
  Widget build(BuildContext context) => isSelected
      ? const SvgIcon(
          asset: Assets.checkmark,
        )
      : CircleBox(
          color: Theme.of(context).secondaryHeaderColor,
          size: 20,
        );
}
