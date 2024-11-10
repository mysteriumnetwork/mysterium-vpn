import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_a.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_b.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_c.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_d.dart';

class SubscriptionFormVariantContainer extends StatelessWidget {
  const SubscriptionFormVariantContainer({
    required this.subscriptionStore,
    required this.localDb,
    required this.analyticsStore,
    required this.variant,
    required this.subscribeToPackage,
    super.key,
  });
  final SubscriptionStore subscriptionStore;
  final LocalDBService localDb;
  final AnalyticsStore analyticsStore;
  final void Function(String selectedProductId) subscribeToPackage;
  final String variant;

  @override
  Widget build(BuildContext context) {
    final shouldApplyHorizontalPadding = variant != 'D';
    return Container(
      width: double.infinity,
      padding: getMediaWidth(context) > 650
          ? EdgeInsets.symmetric(horizontal: shouldApplyHorizontalPadding ? 30 : 0, vertical: 20)
          : getMediaWidth(context) > 950
              ? EdgeInsets.symmetric(
                  horizontal: shouldApplyHorizontalPadding ? 50 : 0,
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
          ),
        'C' => SubscriptionFormVariantC(
            store: subscriptionStore,
            localDb: localDb,
            analyticsStore: analyticsStore,
            variant: variant,
            subscribeToPackage: subscribeToPackage,
          ),
        'D' => SubscriptionFormVariantD(
            store: subscriptionStore,
            localDb: localDb,
            analyticsStore: analyticsStore,
            variant: variant,
            subscribeToPackage: subscribeToPackage,
          ),
        _ => SubscriptionFormVariantA(
            store: subscriptionStore,
            localDb: localDb,
            analyticsStore: analyticsStore,
            variant: variant,
            subscribeToPackage: subscribeToPackage,
          ),
      },
    );
  }
}
