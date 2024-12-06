import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/inherited/parent_scroll_controller.dart';
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

class SubscriptionFormVariantContainer extends HookWidget {
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
    final scrollController = useScrollController();
    final shouldApplyHorizontalPadding = variant != 'D';
    final width = getMediaWidth(context);
    final padding = useMemoized(
      () {
        if (width > 950) {
          return EdgeInsets.symmetric(
            horizontal: shouldApplyHorizontalPadding ? 150 : 0,
            vertical: 20,
          );
        } else if (width > 650) {
          return EdgeInsets.symmetric(
            horizontal: shouldApplyHorizontalPadding ? 80 : 0,
            vertical: 20,
          );
        }
        return EdgeInsets.symmetric(
          horizontal: shouldApplyHorizontalPadding ? 20 : 0,
          vertical: 20,
        );
      },
      [width, shouldApplyHorizontalPadding],
    );

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ParentScrollController(
            controller: scrollController,
            child: SingleChildScrollView(
              padding: padding,
              controller: scrollController,
              child: switch (variant) {
                'A' => SubscriptionFormVariantA(
                    variant: variant,
                    subscribeToPackage: subscribeToPackage,
                  ),
                'B' => SubscriptionFormVariantB(
                    variant: variant,
                    subscribeToPackage: subscribeToPackage,
                  ),
                'C' => SubscriptionFormVariantC(
                    variant: variant,
                    subscribeToPackage: subscribeToPackage,
                  ),
                'D' => SubscriptionFormVariantD(
                    variant: variant,
                    subscribeToPackage: subscribeToPackage,
                  ),
                _ => SubscriptionFormVariantA(
                    variant: variant,
                    subscribeToPackage: subscribeToPackage,
                  ),
              },
            ),
          ),
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
