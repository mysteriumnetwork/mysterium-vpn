import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/shared/components/connection_tile.dart';
import 'package:mysterium_vpn/shared/components/dragable_indicator.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/views/locations_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({required this.constraints, required this.controller, super.key});

  final BoxConstraints constraints;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: MultiSliver(
              children: const [ConnectionTile(), SizedBox(height: 30), LocationsSliverView()],
            ),
          ),
        ),
      ],
    );
  }
}
