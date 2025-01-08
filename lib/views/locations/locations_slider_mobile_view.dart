import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/dragable_indicator.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliderMobileView extends HookConsumerWidget {
  const LocationsSliderMobileView({
    required this.constraints,
    required this.controller,
    super.key,
  });

  final BoxConstraints constraints;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);

    useEffect(
      () {
        controller.addListener(analyticsStore.logLocationsListScroll);
        return () => controller.removeListener(analyticsStore.logLocationsListScroll);
      },
      [analyticsStore],
    );

    void handleTogglePanel() {
      ref.read(homeStateProvider.notifier).togglePanel();
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      slivers: [
        SliverPinnedHeader(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: DraggableIndicator(onTap: handleTogglePanel)),
          ),
        ),
        const SliverClip(
          child: SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: LocationsSliverView(),
            ),
          ),
        ),
      ],
    );
  }
}
