import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_features.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_picker_dialog.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantB extends StatelessWidget {
  const SubscriptionFormVariantB({
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
  Widget build(BuildContext context) => Observer(
        builder: (context) => Column(
          children: [
            EasyText(
              LocaleKeys.pricingPlanTitle.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w900,
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
              onPressed: () => subscribeToPackage(store.products.last.id),
              isLoading: store.isLoading,
              label: LocaleKeys.pricingPlanJoinNowBtn.tr(),
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
            Visibility(
              visible: !store.isLoading,
              child: TextButton(
                onPressed: () {
                  analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
                  shownProductPickerDialog(
                    context: context,
                    analyticsStore: analyticsStore,
                    products: store.products.reversed.toList(),
                    subscribeToPackage: subscribeToPackage,
                    isDarkTheme: isDarkMode,
                    subscriptionStore: store,
                  );
                },
                child: EasyText(
                  LocaleKeys.pricingPlanSeePlansBtn.tr(),
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
        ).scrollable(),
      );
}
