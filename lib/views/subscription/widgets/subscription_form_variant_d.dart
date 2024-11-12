import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/product_list_variant_d.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_features.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantD extends HookWidget {
  const SubscriptionFormVariantD({
    required this.store,
    required this.localDb,
    required this.analyticsStore,
    required this.subscribeToPackage,
    required this.variant,
    required this.isDarkMode,
    super.key,
  });
  final SubscriptionStore store;
  final LocalDBService localDb;
  final AnalyticsStore analyticsStore;
  final void Function(String selectedProductId) subscribeToPackage;
  final String variant;
  final bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    final selectedProductId =
        useState<String>(store.purchasedProductId ?? store.products.lastOrNull?.id ?? kPopularPlan);
    return Observer(
      builder: (context) => Column(
        children: [
          SizedBox(height: getMediaHeight(context) * 0.01),
          EasyText(
            LocaleKeys.pricingPlanTitle.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: getMediaHeight(context) * 0.03),
          SubscriptionProductsListVariantD(
            products: store.products.reversed.toList(),
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
                  isLoading: store.isLoading,
                  label: LocaleKeys.letsGoBtn.tr(),
                ),
                Visibility(
                  visible: Platform.isIOS && !store.isLoading,
                  child: TextButton(
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.redeemOpen);
                      store.redeemCode();
                    },
                    child: EasyText(
                      LocaleKeys.redeemCode.tr(),
                      color: Palette.purple,
                    ),
                  ).padding(top: 10),
                ),
                SizedBox(height: getMediaHeight(context) * 0.025),
                Agreements(
                  analyticsStore: analyticsStore,
                ),
                SizedBox(height: getMediaHeight(context) * 0.025),
              ],
            ),
          ),
        ],
      ).scrollable(),
    );
  }
}
