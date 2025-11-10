import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/highlighted_product.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_features.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_picker_dialog.dart';
import 'package:mysterium_vpn/views/subscription/widgets/redeem_code.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantC extends HookConsumerWidget {
  const SubscriptionFormVariantC({
    required this.subscribeToPackage,
    required this.variant,
    super.key,
  });

  final void Function(String selectedProductId) subscribeToPackage;
  final String variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final isLoading = useComputedValue(() => subscriptionStore.isSubscriptionLoading);
    final products = useComputedValue(
      () => subscriptionStore.productsFuture.value!
          .sortedByCompare((it) => it.duration, compareNums)
          .reversed
          .toList(),
    );
    final highlightedProduct = useComputedValue(() => subscriptionStore.highlightedProduct);

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyText(
            LocaleKeys.pricingPlanTitle.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: getMediaHeight(context) * 0.005),
          if (highlightedProduct != null)
            HighlightedProduct(
              product: highlightedProduct,
              isHighlighted: true,
            ),
          ProductFeatures(
            formVariant: variant,
          ),
          EasyText(
            LocaleKeys.pricingPlanPunchLineTitle.tr(),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ).padding(bottom: getMediaHeight(context) * 0.005),
          EasyText(
            LocaleKeys.pricingPlanPunchLineDesc.tr(),
            maxLines: 3,
            fontSize: 12,
            textAlign: TextAlign.center,
            color: context.c.isDarkMode ? Palette.veryLightGrey : Palette.darkGrey,
          ).padding(bottom: getMediaHeight(context) * 0.005),
          SubscriptionButton(
            onPressed: () {
              if (highlightedProduct == null) {
                return;
              }

              analyticsStore.logEvent(AnalyticsEvent.clickLetsgo);
              subscribeToPackage(highlightedProduct.id);
            },
            isLoading: isLoading,
            label: LocaleKeys.letsGoBtn.tr(),
          ),
          ReedemCode(
            isLoading: isLoading,
            onPressed: subscriptionStore.redeemCode,
          ),
          Visibility(
            visible: !isLoading,
            child: TextButton(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
                shownProductPickerDialog(
                  context: context,
                  products: products,
                  subscribeToPackage: subscribeToPackage,
                  seeAllPlans: true,
                );
              },
              child: EasyText(
                LocaleKeys.pricingPlanSeePlansBtn.tr(),
                color: Palette.purple,
              ),
            ),
          ),
          Agreements(
            analyticsStore: analyticsStore,
          ).padding(top: 6),
          const BottomSpacer(),
        ],
      ),
    );
  }
}
