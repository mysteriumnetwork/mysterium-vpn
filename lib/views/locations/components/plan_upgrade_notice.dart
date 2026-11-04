import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Upgrade prompt shown under the tab disclaimer when the active plan doesn't
/// cover the locations on this tab. Rows stay tappable — this card carries the
/// message, the rows route to the upgrade flow.
///
/// Reports whichever gate actually applies: a plan that includes residential
/// IPs but not city targeting still shows the city message on the residential
/// tab, because the city rows under each country are gated.
class PlanUpgradeNotice extends HookConsumerWidget {
  const PlanUpgradeNotice({required this.locationType, super.key});

  final IPType locationType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final handleUpgradePlan = useHandleUpgradePlan();

    return Observer(
      builder: (context) {
        final message = _message(subscriptionStore, remoteConfigStore);
        if (message == null) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.only(bottom: theme.spacing.s),
          child: StateCard(
            icon: UntitledUI.lock_01,
            message: message,
            actionLabel: S.current.subscriptionUpgrade,
            onActionPressed: handleUpgradePlan,
          ),
        );
      },
    );
  }

  /// The gate to report, or null when nothing on this tab is plan-gated.
  String? _message(SubscriptionStore subscription, RemoteConfigStore remoteConfig) {
    // Only an active, resolved plan can be missing a feature. Without one the
    // rows aren't gated either — they're `unsubscribed`, which the subscription
    // banner already covers.
    if (!subscription.hasResolvedPlan || subscription.isSubscriptionLoading) {
      return null;
    }

    if (locationType == IPType.residential && !subscription.residentialIPsAllowed) {
      return S.current.residentialIpsNotAvailableOnPlan;
    }
    // Cities are only gated when they'd be rendered at all.
    if (remoteConfig.showCitiesAndStates && !subscription.cityLevelAllowed) {
      return S.current.cityIpsNotAvailableOnPlan;
    }
    return null;
  }
}
