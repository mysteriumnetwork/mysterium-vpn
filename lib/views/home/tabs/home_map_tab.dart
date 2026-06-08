import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/subscription_onboarding_setup.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn/views/locations/components/locations_tappable_search.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeMapTab extends HookConsumerWidget {
  const HomeMapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsStore = ref.watch(locationsStorePOD);
    final onboarding = ref.watch(subscriptionOnboardingSetupPOD);

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: theme.palette.bgPrimary),
          child: Padding(
            padding: EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.ms),
            child: Observer(
              builder: (context) {
                final stepIndex = onboarding.stepIndex(SubscriptionOnboardingSetup.searchIndex);

                return ArrowedProgressCard(
                  tooltipIndex: stepIndex,
                  totalTooltips: onboarding.visibleStepsCount,
                  tooltipContent: onboarding.searchTooltipContent,
                  globalKey: onboarding.searchKey,
                  tooltipPosition: TooltipPosition.bottom,
                  icon: onboarding.searchTooltipContent.icon,
                  onActionPressed: () => ShowcaseView.get().next(),
                  child: LocationsTappableSearch(
                    enabled: !locationsStore.hasNoServers,
                    onTap: () => ref.read(homeTabsStorePOD).openLocationsSearch(),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: HomeConnectionView()),
              Positioned(
                left: theme.spacing.md,
                right: theme.spacing.md,
                bottom: theme.spacing.md,
                child: Observer(
                  builder: (context) => locationsStore.hasNoServers
                      ? const SizedBox.shrink()
                      : const ConnectionTile(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
