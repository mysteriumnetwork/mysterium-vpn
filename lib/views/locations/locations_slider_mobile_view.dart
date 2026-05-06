import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({required this.constraints, required this.controller, super.key});

  final BoxConstraints constraints;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final panelState = ref.watch(homeStateProvider.select((s) => s.panelState));

    useEffect(() {
      controller.addListener(analyticsStore.logLocationsListScroll);
      return () => controller.removeListener(analyticsStore.logLocationsListScroll);
    }, [analyticsStore]);

    // When the panel is not fully open, reset the scroll to the top so the
    // list always starts fresh when the panel is reopened.
    useEffect(() {
      if (panelState != PanelState.open && controller.hasClients && controller.offset != 0) {
        controller.jumpTo(0);
      }
      return null;
    }, [panelState]);

    void handleTogglePanel() {
      ref.read(homeStateProvider.notifier).togglePanel();
    }

    return CustomScrollView(
      physics: switch (panelState) {
        PanelState.open => const AlwaysScrollableScrollPhysics(),
        _ => const NeverScrollableScrollPhysics(),
      },
      dragStartBehavior: DragStartBehavior.down,
      controller: controller,
      slivers: [
        SliverPinnedHeader(
          child: Center(child: DraggableIndicator(onTap: handleTogglePanel)),
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Theme.of(context).spacing.md),
            sliver: MultiSliver(
              children: [
                Observer(
                  builder: (context) => locationsStore.hasNoServers
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(bottom: Theme.of(context).spacing.xl3),
                          child: const ConnectionTile(),
                        ),
                ),
                const LocationsSliverView(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
