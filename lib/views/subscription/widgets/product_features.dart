import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class ProductFeatures extends StatelessWidget {
  const ProductFeatures({
    required this.formVariant,
    required this.isDarkTheme,
    super.key,
  });
  final String formVariant;
  final bool isDarkTheme;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: EasyText(
                LocaleKeys.pricingPlanFeatures.tr(),
              ),
            ),
            SizedBox(height: getMediaHeight(context) * 0.01),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocaleKeys.pricingPlanFeatures1.tr(),
                LocaleKeys.pricingPlanFeatures2.tr(),
                LocaleKeys.pricingPlanFeatures3.tr(),
                if (formVariant == 'B') ...[
                  LocaleKeys.pricingPlanFeatures4.tr(),
                  LocaleKeys.pricingPlanFeatures5.tr(),
                ],
                LocaleKeys.pricingPlanFeatures6.tr(),
              ]
                  .map(
                    (e) => _FeatureItem(
                      title: e,
                      isDarkTheme: isDarkTheme,
                      isLastItem: e == LocaleKeys.pricingPlanFeatures6.tr(),
                    ),
                  )
                  .toList(),
            ).padding(all: 16).card(
                  color: isDarkTheme ? const Color(0xff353355) : const Color(0xffF5F3FD),
                ),
          ],
        ),
      );
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.title,
    required this.isDarkTheme,
    this.isLastItem = false,
  });
  final String title;
  final bool isLastItem;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SvgIcon(
                  asset: Assets.checkmark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EasyText(
                    title,
                    fontSize: 14,
                    color: isDarkTheme ? const Color(0xffC4C1DD) : const Color(0xFF716F8A),
                  ),
                ),
              ],
            ),
            if (!isLastItem)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Divider(
                  color: isDarkTheme ? const Color(0xFF6a678e) : const Color(0x66A6A3C9),
                  thickness: 1,
                  height: 1,
                ),
              ),
          ],
        ),
      );
}
