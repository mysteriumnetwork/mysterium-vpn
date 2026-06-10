import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/subscription_upgrade_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'all_plans_section.dart';
part 'manage_on_store_view.dart';
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
          final subscription = subscriptionStore.subscriptionFuture.value;
          final hasActiveSub = subscription?.active ?? false;
          // Wait for the subscription so we don't pick a branch with stale
          // data. The max-plan branch also needs the config, so for active
          // subs hold the loader until the config resolves too — otherwise we
          // briefly show the web/store branch before flipping to max-plan.
          final waitingForConfig =
              hasActiveSub &&
              subscriptionStore.subscriptionConfigFuture.status == FutureStatus.pending;
          if (subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
              waitingForConfig) {
            return const Center(child: LoadingIndicator());
          }
          // On the highest plan available to the user (per their gateway):
          // nothing to upgrade, so this wins over every management screen.
          // Store subs count their store's top plan as the ceiling, so a
          // store-max sub shows "highest plan" on every platform.
          if (subscriptionStore.isOnMaxPlan) {
            return const _MaxPlanView();
          }
          // Active store (Apple/Google) sub that isn't on its store's max plan,
          // viewed where it can't be upgraded (e.g. on Windows): direct the
          // user back to the originating store, never the web flow.
          if (subscriptionStore.isStoreSubOnForeignPlatform) {
            return const _ManageOnStoreView();
          }
          // Web-paid subs (and Windows first-time buyers) manage/subscribe
          // online.
          if (subscriptionStore.useWebFlow) {
            return const _ManageOnWebView();
          }
          return BackgroundGradient(
            child: SubscriptionStatusContainer(
              child: SubscriptionUpgradeView(
                onShowAllPlansPressed: () => showSubscriptionPlansModalPage(context),
                // Tab variant has no app-bar above; Figma spec is 40px below safe area.
                contentPadding: ModalPadding.insets(
                  context,
                  add: EdgeInsets.only(top: theme.spacing.xl4),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
