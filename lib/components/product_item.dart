import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/decorated_label.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:styled_widget/styled_widget.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    required this.productDetails,
    required this.selectedProduct,
    super.key,
  });

  final PurchasableProduct productDetails;
  final ValueNotifier<String> selectedProduct;

  @override
  Widget build(BuildContext context) => RippleWidget(
        radius: 20,
        onTap: () => selectedProduct.value = productDetails.id,
        child: Row(
          children: [
            const SvgIcon(
              asset: Assets.subscriptionItem,
            ).padding(right: getMediaWidth(context) * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  productDetails.id.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                Row(
                  children: [
                    EasyText(
                      productDetails.originalMonthlyPrice,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    EasyText(
                      LocaleKeys.currentPrice
                          .tr(namedArgs: {'amount': productDetails.monthlyPrice}),
                      color: Palette.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ).fittedBox(),
                EasyText(
                  productDetails.billedInTotal,
                  color: Theme.of(context).secondaryHeaderColor,
                ).fittedBox()
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
                  else ...[
                    _CheckMark(
                      isSelected: productDetails.id == selectedProduct.value,
                    ),
                    if (productDetails.status == ProductStatus.purchased)
                      DecoratedLabel(
                        text: LocaleKeys.purchased.tr(),
                        color: Palette.green,
                      ).padding(top: 8)
                    else if (productDetails.isPupular)
                      DecoratedLabel(
                        text: LocaleKeys.popular.tr(),
                      ).padding(top: 8)
                  ],
                ],
              ).padding(left: 14),
            ),
          ],
        ).padding(all: 14).height(105).decorated(
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
