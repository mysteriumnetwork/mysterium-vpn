import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/arrowed_progress_card.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
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
    final globalKeys = useMemoized(
      () => List.generate(tabs.length + 3, (index) => GlobalKey<State<StatefulWidget>>()),
    );
    final tooltipContents = [
      TooltipContent(
        title: 'Explore locations your way',
        description: 'Browse the map or explore locations from the sidebar.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
      TooltipContent(
        title: 'Manage your plan',
        description: 'Purchase, upgrade or view available plans based on your account access.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
      TooltipContent(
        title: 'Boost your protection',
        description: 'Explore advanced features like VPN protocols and malware blocking.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
      TooltipContent(
        title: 'Connect to stay private',
        description: 'We will connect you to the best server.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
      TooltipContent(
        title: 'Search and connect faster',
        description: 'Quickly find countries, cities and servers with search.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
      TooltipContent(
        title: 'Browse VPN locations',
        description: 'Explore countries and cities in one place.',
        actionLabel: 'Continue',
        onActionPressed: () => ShowcaseView.get().next(),
      ),
    ];

    // Normalize when a mobile-only tab survives a resize to desktop.
    useEffect(() {
      if (!tabs.contains(selected)) {
        WidgetsBinding.instance.addPostFrameCallback((_) => store.trySelect(HomeTab.map));
      }
      return null;
    }, [selected]);

    useEffect(() {
      ShowcaseView.register(
        globalFloatingActionWidget: (context) => FloatingActionWidget(
          top: 50,
          right: 50,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Palette.white),
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
            ),
            icon: Row(
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    color: Palette.grayDark.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.close, color: Palette.grayDark.shade700, size: 20),
              ],
            ),
            onPressed: () => ShowcaseView.get().dismiss(),
          ),
        ),
      );

      // TODO: Testing delete after
      Future.microtask(() async {
        await Future.delayed(const Duration(seconds: 3));
        ShowcaseView.get().startShowCase(globalKeys);
      });

      return ShowcaseView.get().unregister;
    }, []);

    final selectedIndex = tabs.indexOf(selected).clamp(0, tabs.length - 1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NavRail(
          currentIndex: selectedIndex,
          itemWrapper: ({required context, required index, required item, required child}) =>
              ArrowedProgressCard(
                tooltipIndex: index,
                totalTooltips: tooltipContents.length,
                tooltipContent: tooltipContents[index],
                globalKey: globalKeys[index],
                tooltipPosition: TooltipPosition.right,
                child: child,
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
