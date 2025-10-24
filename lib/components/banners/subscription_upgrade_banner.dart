import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class SubscriptionUpgradeBanner extends HookConsumerWidget {
  const SubscriptionUpgradeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionUpgradeStore = ref.read(subscriptionUpgradeStorePOD);

    return Observer(
      builder: (context) {
        Future<void> handleUpgrade() async {
          await showSubscriptionUpgradePage(context);
        }

        final product = subscriptionUpgradeStore.upgradeProduct.value;
        final discountPercent = subscriptionUpgradeStore.upgradeDiscountPercent;
        if (product == null || discountPercent == null) {
          return const SizedBox.shrink();
        }

        final planName = switch (product.planDetails.id) {
          kAnnualPlan => LocaleKeys.plan_yearly.tr(),
          ksemiAnnualPlan => LocaleKeys.plan_6_months.tr(),
          kMonthlyPlan => LocaleKeys.plan_monthly.tr(),
          _ => LocaleKeys.plan_2_years.tr(),
        };

        return RawMaterialButton(
          onPressed: handleUpgrade,
          visualDensity: VisualDensity.compact,
          elevation: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          fillColor: Palette.lavenderPink,
          constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Asset.icons.diamond.svg(width: 24, height: 24),
                    Flexible(
                      flex: 3,
                      child: EasyText(
                        LocaleKeys.saveWithPlan.tr(args: [discountPercent.toString(), planName]),
                        color: Palette.midnightCharcoal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: IconButton(
                  onPressed: handleUpgrade,
                  icon: const Icon(Icons.chevron_right),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
