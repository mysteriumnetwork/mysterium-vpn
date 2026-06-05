import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/subscription_onboarding_hook.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_setup_subscription_onboarding.dart';
import 'package:mysterium_vpn/views/home/tabs/home_products_tab/home_products_tab.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeDesktopScaffold extends HookConsumerWidget {
  const HomeDesktopScaffold({super.key});

  static Widget _pageFor(HomeTab tab) => switch (tab) {
    HomeTab.map => const HomeDesktopView(),
    HomeTab.products => const HomeProductsTab(),
    HomeTab.settings => const SettingsDesktopView(),
    // Locations is folded into Map on desktop and never reaches this switch
    // because [HomeTab.desktopTabs] filters it out; render nothing as a guard.
    HomeTab.locations => const SizedBox.shrink(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(homeTabsStorePOD);
    final selected = useComputedValue(() => store.selected);

    final tabs = HomeTab.desktopTabs();

    // Normalize when a mobile-only tab survives a resize to desktop.
    useEffect(() {
      if (!tabs.contains(selected)) {
        WidgetsBinding.instance.addPostFrameCallback((_) => store.trySelect(HomeTab.map));
      }
      return null;
    }, [selected]);

    final selectedIndex = tabs.indexOf(selected).clamp(0, tabs.length - 1);

    final (tooltipContents, globalKeys) = setupSubscriptionOnboarding(keysCount: 6);
    useSubscriptionOnboarding(globalKeys);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavRail(
          currentIndex: selectedIndex,
          itemWrapper: ({required context, required index, required item, required child}) =>
              SizedBox(
                width: 32,
                height: 32,
                child: ArrowedProgressCard(
                  tooltipIndex: index,
                  totalTooltips: tooltipContents.length,
                  tooltipContent: tooltipContents[index],
                  globalKey: globalKeys[index],
                  tooltipPosition: TooltipPosition.right,
                  child: child,
                ),
              ),
          items: [
            for (var i = 0; i < tabs.length; i++)
              NavRailItem(
                icon: tabs[i].icon,
                label: tabs[i].label(),
                onTap: () {
                  if (!store.trySelect(tabs[i])) {
                    Beamer.of(context).beamToNamed(Routes.platformLogin.path);
                  }
                },
              ),
          ],
        ),
        Expanded(
          child: IndexedStack(
            index: selectedIndex,
            children: [for (final tab in tabs) _pageFor(tab)],
          ),
        ),
      ],
    );
  }
}
