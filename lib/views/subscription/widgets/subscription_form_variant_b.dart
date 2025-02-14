import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_features.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_picker_dialog.dart';
import 'package:mysterium_vpn/views/subscription/widgets/redeem_code.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantB extends HookConsumerWidget {
  const SubscriptionFormVariantB({
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
    final isLoading = useComputedValue(() => subscriptionStore.isLoading);
    final products = useComputedValue(
      () => subscriptionStore.products
          .sortedByCompare((it) => it.duration, compareNums)
          .reversed
          .toList(),
    );

    return Observer(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyText(
              LocaleKeys.pricingPlanTitle.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: getMediaHeight(context) * 0.01),
            ProductFeatures(
              formVariant: variant,
              isDarkTheme: isDarkMode,
            ),
            SizedBox(height: getMediaHeight(context) * 0.04),
            EasyText(
              LocaleKeys.pricingPlanDiscountTitle.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: getMediaHeight(context) * 0.01),
            EasyText(
              LocaleKeys.pricingPlanDiscountDesc.tr(),
              maxLines: 3,
              fontSize: 12,
              textAlign: TextAlign.center,
              color: isDarkMode ? Palette.veryLightGrey : Palette.darkGrey,
            ),
            SizedBox(height: getMediaHeight(context) * 0.04),
            SubscriptionButton(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.clickSave49ByJoining);
                shownProductPickerDialog(
                  context: context,
                  products: products,
                  subscribeToPackage: subscribeToPackage,
                  seeAllPlans: false,
                );
              },
              isLoading: isLoading,
              label: LocaleKeys.pricingPlanJoinNowBtn.tr(),
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
            ).padding(top: 10),
            const BottomSpacer(),
          ],
        ),
      ),
    );
  }
}
