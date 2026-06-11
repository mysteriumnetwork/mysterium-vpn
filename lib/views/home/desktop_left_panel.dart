import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/home/subscription_onboarding_showcase.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeDesktopLeftPanel extends HookConsumerWidget {
  const HomeDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final scrollController = useScrollController()
      ..addListener(analyticsStore.logLocationsListScroll);
    final brightness = useScaffoldBrightness();
    final onboarding = ref.watch(subscriptionOnboardingShowcaseControllerPOD);

    useEffect(() {
      final homeState = ref.read(homeStateProvider)..scrollController = scrollController;
      return () {
        if (homeState.scrollController == scrollController) {
          homeState.scrollController = null;
        }
      };
    }, [scrollController]);

    final pallete = Theme.of(context).palette;
    final spacing = Theme.of(context).spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pallete.bgSidePanel,
        boxShadow: [
          switch (brightness) {
            Brightness.dark => BoxShadow(
              color: pallete.bgPrimary.withValues(alpha: .2),
              blurRadius: 100,
            ),
            Brightness.light => BoxShadow(
              color: pallete.bgPrimary.withValues(alpha: .04),
              blurRadius: 16,
              offset: const Offset(4, -4),
            ),
          },
        ],
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPinnedHeader(
            child: DecoratedBox(
              decoration: BoxDecoration(color: pallete.bgSidePanel),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Header.logo(
                    showBackButton: false,
                    backgroundColor: pallete.bgSidePanel,
                    actions: const [HelpSupportIconButton()],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(spacing.xl3, spacing.s, spacing.xl3, spacing.xl3),
                    child: Observer(
                      builder: (context) {
                        final search = LocationsSearch(enabled: !locationsStore.hasNoServers);
                        if (onboarding == null) {
                          return search;
                        }

                        final target = onboarding.targetForStep(SubscriptionOnboardingStep.search);

                        return ArrowedProgressCard(
                          tooltipIndex: target.index,
                          totalTooltips: target.totalSteps,
                          tooltipContent: target.spec.content,
                          globalKey: target.key,
                          tooltipPosition: target.spec.position,
                          scope: target.scope,
                          icon: target.spec.content.icon,
                          onActionPressed: onboarding.next,
                          child: search,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverClip(
            child: SliverPadding(padding: EdgeInsets.zero, sliver: LocationsSliverView()),
          ),
        ],
      ),
    );
  }
}
