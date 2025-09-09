import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ProductFeatures extends HookConsumerWidget {
  const ProductFeatures({
    required this.formVariant,
    super.key,
  });

  final String formVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigStorePOD);
    final pricingMonthly = useComputedValue(() => config.pricingMonthly);

    final features = [
      LocaleKeys.pricingPlanFeatures1.tr(),
      LocaleKeys.pricingPlanFeatures2.tr(),
      LocaleKeys.pricingPlanFeatures3.tr(),
      if (formVariant == 'B') ...[
        LocaleKeys.pricingPlanFeatures4.tr(),
        LocaleKeys.pricingPlanFeatures5.tr(),
      ],
      if (pricingMonthly) LocaleKeys.pricingPlanFeatures6.tr(),
    ];

    return Padding(
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
            children: features
                .mapIndexed(
                  (i, e) => _FeatureItem(
                    title: e,
                    isLastItem: i == features.length - 1,
                  ),
                )
                .toList(),
          ).padding(all: 16).card(
                color: context.c.isDarkMode ? const Color(0xff353355) : const Color(0xffF5F3FD),
              ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.title,
    this.isLastItem = false,
  });

  final String title;
  final bool isLastItem;

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
                SvgIcon(asset: Asset.icons.checkmark),
                const SizedBox(width: 10),
                Expanded(
                  child: EasyText(
                    title,
                    fontSize: 14,
                    color: context.c.isDarkMode ? const Color(0xffC4C1DD) : const Color(0xFF716F8A),
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
                  color: context.c.isDarkMode ? const Color(0xFF6a678e) : const Color(0x66A6A3C9),
                  thickness: 1,
                  height: 1,
                ),
              ),
          ],
        ),
      );
}
