import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/hooks/ab_test_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_a.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_b.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_c.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_d.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form_variant_e.dart';

class SubscriptionForm extends HookConsumerWidget {
  const SubscriptionForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = useABTest((store) => store.subscriptionFlowVariant);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    final shouldApplyHorizontalPadding = variant != 'D';
    final width = getMediaWidth(context);
    final padding = useMemoized(
      () {
        var padding = EdgeInsets.only(
          top: variant != 'E' ? 20 : 0,
          bottom: 36,
        );
        if (shouldApplyHorizontalPadding) {
          padding = switch (width) {
            > 950 => padding.copyWith(left: 150, right: 150),
            > 650 => padding.copyWith(left: 80, right: 80),
            _ => padding.copyWith(left: 20, right: 20),
          };
        }

        return padding;
      },
      [width, shouldApplyHorizontalPadding, variant],
    );

    Future<void> handleSubscribe(String productId) async {
      await _subscribeToPackage(
        analyticsStore,
        subscriptionStore,
        subscriptionStore.products.map((e) => e.id).toList(),
        productId,
      );
    }

    return Padding(
      padding: padding,
      child: switch (variant) {
        'A' => SubscriptionFormVariantA(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
        'B' => SubscriptionFormVariantB(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
        'C' => SubscriptionFormVariantC(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
        'D' => SubscriptionFormVariantD(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
        'E' => SubscriptionFormVariantE(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
        _ => SubscriptionFormVariantA(
            subscribeToPackage: handleSubscribe,
            variant: variant,
          ),
      },
    );
  }
}

Future<void> _subscribeToPackage(
  AnalyticsStore analyticsStore,
  SubscriptionStore store,
  List<String> productIds,
  String selectedProductId,
) async {
  final selectedProduct = store.products.firstWhere((element) => element.id == selectedProductId);
  analyticsStore.logEvent(
    AnalyticsEvent.subscriptionNew,
    parameters: {'item_ids': productIds},
  );

  store.subscribeToPackage(product: selectedProduct.productDetails);
}
