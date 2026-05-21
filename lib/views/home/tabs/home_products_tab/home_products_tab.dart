import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/subscription_upgrade_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'all_plans_section.dart';
part 'manage_on_web_view.dart';
part 'max_plan_view.dart';
part 'products_browsing_view.dart';

class HomeProductsTab extends HookConsumerWidget {
  const HomeProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    return ColoredBox(
      color: theme.palette.bgSidePanel,
      child: Observer(
        builder: (context) {
          // useWebFlow short-circuits true on Windows; wait for the sub
          // so we don't pick a branch with stale data.
          if (subscriptionStore.subscriptionFuture.status == FutureStatus.pending) {
            return const Center(child: LoadingIndicator());
          }
          if (subscriptionStore.isOnMaxPlan) {
            return const _MaxPlanView();
          }
          if (subscriptionStore.useWebFlow) {
            return const _ManageOnWebView();
          }
          return SubscriptionStatusContainer(
            child: SubscriptionUpgradeView(
              onShowAllPlansPressed: () => showSubscriptionPlansModalPage(context),
            ),
          );
        },
      ),
    );
  }
}
