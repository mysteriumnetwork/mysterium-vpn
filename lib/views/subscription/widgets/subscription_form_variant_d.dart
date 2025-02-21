import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/product_list_variant_d.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_features.dart';
import 'package:mysterium_vpn/views/subscription/widgets/redeem_code.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantD extends HookConsumerWidget {
  const SubscriptionFormVariantD({
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

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLoading = useComputedValue(() => subscriptionStore.isSubscriptionLoading);
    final products = useComputedValue(
      () => subscriptionStore.productsFuture.value!
          .sortedByCompare((it) => it.duration, compareNums)
          .reversed
          .toList(),
    );

    final highlightedProduct = useComputedValue(() => subscriptionStore.highlightedProduct!);
    final selectedProductId = useState<String>(
      subscriptionStore.subscriptionFuture.value?.planId ?? highlightedProduct.id,
    );

    return Observer(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getMediaHeight(context) * 0.01),
            EasyText(
              LocaleKeys.pricingPlanTitle.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: getMediaHeight(context) * 0.03),
            SubscriptionProductsListVariantD(
              products: products,
              selectedProductId: selectedProductId,
            ),
            Padding(
              padding: getMediaWidth(context) > 950
                  ? const EdgeInsets.symmetric(
                      horizontal: 100,
                    )
                  : getMediaWidth(context) > 650
                      ? const EdgeInsets.symmetric(
                          horizontal: 70,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductFeatures(
                    formVariant: variant,
                    isDarkTheme: isDarkMode,
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
                    color: isDarkMode ? Palette.veryLightGrey : Palette.darkGrey,
                  ).padding(bottom: getMediaHeight(context) * 0.025),
                  SubscriptionButton(
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.clickLetsgo);
                      subscribeToPackage(selectedProductId.value);
                    },
                    isLoading: isLoading,
                    label: LocaleKeys.letsGoBtn.tr(),
                  ),
                  ReedemCode(
                    isLoading: isLoading,
                    onPressed: subscriptionStore.redeemCode,
                  ),
                  Agreements(
                    analyticsStore: analyticsStore,
                  ).padding(top: 10),
                  const BottomSpacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
