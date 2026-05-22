import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/subscription_upgrade_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionUpgradeModalPage(BuildContext context) async {
  ProviderScope.containerOf(
    context,
    listen: false,
  ).read(analyticsStorePOD).logScreenViewed('subscription_upgrade_modal').ignore();
  await showModal(context, builder: (context) => const _SubscriptionUpgradeModalPage());
}

class _SubscriptionUpgradeModalPage extends StatelessWidget {
  const _SubscriptionUpgradeModalPage();

  @override
  Widget build(BuildContext context) => ModalScaffold(
    autoApplyPadding: false,
    body: SubscriptionStatusContainer(
      child: SubscriptionUpgradeView(
        onShowAllPlansPressed: () {
          Navigator.of(context).pop();
          showSubscriptionPlansModalPage(context);
        },
        onPurchaseComplete: () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    ),
  );
}
