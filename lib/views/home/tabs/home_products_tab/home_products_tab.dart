import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/payment_gateway.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
          // Branch order and rationale live in `resolveProductsScreenVariant`;
          // the same getter drives `products_tab_viewed` analytics so the
          // rendered and logged variants can't diverge.
          switch (subscriptionStore.productsScreenVariant) {
            case ProductsScreenVariant.loading:
              return const Center(child: LoadingIndicator());
            case ProductsScreenVariant.maxPlan:
              return const _MaxPlanView();
            case ProductsScreenVariant.manageOnStore:
              return const _ManageOnStoreView();
            case ProductsScreenVariant.manageOnWeb:
              return const _ManageOnWebView();
            case ProductsScreenVariant.defaultUpgrade:
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
          }
        },
      ),
    );
  }
}
