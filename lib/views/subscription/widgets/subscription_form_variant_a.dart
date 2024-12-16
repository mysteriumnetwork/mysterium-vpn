import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/product_list_variant_a.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/redeem_code.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantA extends HookConsumerWidget {
  const SubscriptionFormVariantA({
    required this.subscribeToPackage,
    required this.variant,
    super.key,
  });

  final String variant;
  final void Function(String selectedProductId) subscribeToPackage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final isLoading = useComputedValue(() => subscriptionStore.isLoading);
    final products = useComputedValue(
      () => subscriptionStore.products
          .sortedByCompare((it) => it.duration, compareNums)
          .reversed
          .toList(),
    );
    final highlightedProduct = useComputedValue(() => subscriptionStore.highlightedProduct);
    final selectedProductId = useState<String>(
      subscriptionStore.purchasedProductId ?? highlightedProduct.id,
    );

    return Observer(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyText(
              LocaleKeys.selectPackage.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: getMediaHeight(context) * 0.015),
            SubscriptionProductsListVariantA(
              products: products,
              selectedProductId: selectedProductId,
            ).padding(bottom: getMediaHeight(context) * 0.02),
            EasyText(
              LocaleKeys.freeTrialTitle.tr(),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ).padding(bottom: getMediaHeight(context) * 0.005),
            EasyText(
              LocaleKeys.freeTrialDesc.tr(),
              maxLines: 3,
              fontSize: 14,
              textAlign: TextAlign.center,
            ).padding(bottom: getMediaHeight(context) * 0.025),
            SubscriptionButton(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.clickStartNow);
                subscribeToPackage(selectedProductId.value);
              },
              isLoading: isLoading,
              label: LocaleKeys.startTrialBtn.tr(),
            ),
            ReedemCode(
              isLoading: isLoading,
              onPressed: subscriptionStore.redeemCode,
            ),
            SizedBox(height: getMediaHeight(context) * 0.01),
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
