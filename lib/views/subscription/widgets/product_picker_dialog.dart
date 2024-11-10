// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/highlighted_product.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownProductPickerDialog({
  required BuildContext context,
  required AnalyticsStore analyticsStore,
  required List<PurchasableProduct> products,
  required SubscriptionStore subscriptionStore,
  required void Function(String selectedProductId) subscribeToPackage,
  required bool isDarkTheme,
}) async {
  showModalBottomSheet(
    clipBehavior: Clip.none,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _ProductPickerDialog(
        analyticsStore: analyticsStore,
        products: products,
        subscriptionStore: subscriptionStore,
        subscribeToPackage: subscribeToPackage,
        isDarkTheme: isDarkTheme,
      ),
    ),
  );
}

class _ProductPickerDialog extends HookWidget {
  const _ProductPickerDialog({
    required this.subscriptionStore,
    required this.analyticsStore,
    required this.products,
    required this.subscribeToPackage,
    required this.isDarkTheme,
  });
  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;
  final List<PurchasableProduct> products;
  final void Function(String selectedProductId) subscribeToPackage;
  final bool isDarkTheme;
  @override
  Widget build(BuildContext context) {
    final selectedProductId = useState<String>(
      subscriptionStore.purchasedProductId ?? subscriptionStore.products.last.id,
    );
    final seeAllPlans = useState(false);
    return Observer(
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: SvgIconButton(
                asset: isDarkTheme ? Assets.deleteAccountDark : Assets.deleteAccountLight,
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EasyText(
                seeAllPlans.value
                    ? LocaleKeys.selectYourSubscription.tr()
                    : LocaleKeys.pricingPlanTitle.tr(),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: getMediaHeight(context) * 0.02),
              if (seeAllPlans.value)
                ...products.reversed.map(
                  (product) => HighlightedProduct(
                    selectProdcut: () {
                      selectedProductId.value = product.id;
                    },
                    product: product,
                    isDarkTheme: isDarkTheme,
                    monthlyRawPrice: products.first.rawPrice,
                    isHighlighted: false,
                    showDiscountTag: product.id == products.last.id,
                    isSelected: selectedProductId.value == product.id,
                  ),
                )
              else
                HighlightedProduct(
                  product: products.last,
                  isDarkTheme: isDarkTheme,
                  monthlyRawPrice: products.first.rawPrice,
                  showDiscountTag: true,
                  isHighlighted: false,
                ),
              SizedBox(height: getMediaHeight(context) * 0.04),
              SubscriptionButton(
                onPressed: () => subscribeToPackage(selectedProductId.value),
                isLoading: subscriptionStore.subscriptonStatus == SubscriptionStatus.verifying,
                label: LocaleKeys.startTrialBtn.tr(),
              ),
              if (!seeAllPlans.value)
                TextButton(
                  onPressed: () {
                    seeAllPlans.value = !seeAllPlans.value;
                  },
                  child: EasyText(
                    LocaleKeys.pricingPlanSeePlansBtn.tr(),
                    color: Palette.purple,
                  ),
                ).padding(top: getMediaHeight(context) * 0.01),
              const BottomSpacer(),
            ],
          ).padding(horizontal: 20, vertical: 20),
        ],
      ),
    );
  }
}
