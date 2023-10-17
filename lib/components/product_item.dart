import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem({
    required this.productDetails,
    super.key,
  });

  final PurchasableProduct productDetails;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsStore = ref.watch(subscriptionStorePOD);

    return RippleWidget(
      radius: 20,
      onTap: () => subsStore.selectedProductId = productDetails.id,
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
                fontWeight: FontWeight.w700,
              ),
              Row(
                children: [
                  EasyText(
                    productDetails.billedInTotal,
                    color: Palette.purple,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
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
                else ...[
                  _CheckMark(
                    isSelected: productDetails.id == subsStore.selectedProductId,
                    isPurchased: productDetails.id == subsStore.purchasedProductId,
                    isSusbActive: subsStore.isSubscribed ?? false,
                  ),
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
}

class _CheckMark extends StatelessWidget {
  const _CheckMark({
    required this.isSelected,
    required this.isPurchased,
    required this.isSusbActive,
  });

  final bool isSelected;
  final bool isPurchased;
  final bool isSusbActive;
  @override
  Widget build(BuildContext context) => isPurchased && isSelected && isSusbActive
      ? const Icon(Icons.check_circle, color: Palette.green)
      : isSelected
          ? const SvgIcon(
              asset: Assets.checkmark,
            )
          : CircleBox(
              color: Theme.of(context).secondaryHeaderColor,
              size: 20,
            );
}
