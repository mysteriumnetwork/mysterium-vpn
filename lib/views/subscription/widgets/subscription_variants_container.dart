import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_a.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_b.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_c.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_d.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantContainer extends StatelessWidget {
  const SubscriptionFormVariantContainer({
    required this.subscriptionStore,
    required this.localDb,
    required this.analyticsStore,
    required this.variant,
    required this.subscribeToPackage,
    required this.isDarkMode,
    required this.isVerifingPayment,
    super.key,
  });
  final SubscriptionStore subscriptionStore;
  final LocalDBService localDb;
  final AnalyticsStore analyticsStore;
  final void Function(String selectedProductId) subscribeToPackage;
  final String variant;
  final bool isDarkMode;
  final bool isVerifingPayment;
  @override
  Widget build(BuildContext context) {
    final shouldApplyHorizontalPadding = variant != 'D';
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: getMediaWidth(context) > 950
              ? EdgeInsets.symmetric(
                  horizontal: shouldApplyHorizontalPadding ? 150 : 0,
                  vertical: 20,
                )
              : getMediaWidth(context) > 650
                  ? EdgeInsets.symmetric(
                      horizontal: shouldApplyHorizontalPadding ? 80 : 0,
                      vertical: 20,
                    )
                  : EdgeInsets.symmetric(
                      horizontal: shouldApplyHorizontalPadding ? 20 : 0,
                      vertical: 20,
                    ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: switch (variant) {
            'A' => SubscriptionFormVariantA(
                store: subscriptionStore,
                localDb: localDb,
                analyticsStore: analyticsStore,
                variant: variant,
                subscribeToPackage: subscribeToPackage,
              ),
            'B' => SubscriptionFormVariantB(
                store: subscriptionStore,
                localDb: localDb,
                analyticsStore: analyticsStore,
                variant: variant,
                subscribeToPackage: subscribeToPackage,
                isDarkMode: isDarkMode,
              ),
            'C' => SubscriptionFormVariantC(
                store: subscriptionStore,
                localDb: localDb,
                analyticsStore: analyticsStore,
                variant: variant,
                subscribeToPackage: subscribeToPackage,
                isDarkMode: isDarkMode,
              ),
            'D' => SubscriptionFormVariantD(
                store: subscriptionStore,
                localDb: localDb,
                analyticsStore: analyticsStore,
                variant: variant,
                subscribeToPackage: subscribeToPackage,
                isDarkMode: isDarkMode,
              ),
            _ => SubscriptionFormVariantA(
                store: subscriptionStore,
                localDb: localDb,
                analyticsStore: analyticsStore,
                variant: variant,
                subscribeToPackage: subscribeToPackage,
              ),
          },
        ),
        if (isVerifingPayment)
          LoadingBarrier(
            color: Palette.darkBlue,
            child: Center(
              child: LoadingIndicator(
                radius: 50,
                strokeWidth: 3,
                message: LocaleKeys.processingPayment.tr(),
                messageColor: Palette.black,
              )
                  .decorated(
                    color: Palette.white,
                    borderRadius: BorderRadius.circular(10),
                  )
                  .padding(all: 20)
                  .constrained(width: getMediaWidth(context) * 0.8, height: 200),
            ),
          ),
      ],
    );
  }
}
