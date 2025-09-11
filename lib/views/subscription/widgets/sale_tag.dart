import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class SaleTag extends HookWidget {
  const SaleTag({
    required this.discountPercentage,
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;
  final int discountPercentage;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Asset.icons.tag.svg(
              height: 240,
              fit: BoxFit.fill,
            ),
            Positioned.fill(
              child: Column(
                children: [
                  Asset.icons.barcode.svg(
                    fit: BoxFit.fill,
                    allowDrawingOutsideViewBox: true,
                    alignment: Alignment.topLeft,
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: EasyText(
                                LocaleKeys.pricingPlanSaleTag.tr(),
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: Palette.white,
                              ),
                            ),
                            if (discountPercentage > 0)
                              EasyText(
                                '-$discountPercentage%',
                                fontWeight: FontWeight.w700,
                                fontSize: 36,
                                color: Palette.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      );
}
