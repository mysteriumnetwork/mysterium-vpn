import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';

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

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      slivers: const [
        SliverSafeArea(
          sliver: SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: LocationsSliverView(),
          ),
        ),
      ],
    );
  }
}
