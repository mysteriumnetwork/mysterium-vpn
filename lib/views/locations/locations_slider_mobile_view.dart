import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connection_tile.dart';
import 'package:mysterium_vpn/components/dragable_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/models/location.dart';
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
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final homeState = ref.watch(homeStateProvider);

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
      physics: switch (homeState.panelState) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: MultiSliver(
              children: [
                Observer(
                  builder: (context) {
                    final selectedLocation = selectedLocationStore.value;
                    final showBanner = selectedLocation != null && vpnStore.isConnected;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showBanner)
                          _SelectedLocationBanner(
                            location: selectedLocation,
                            onDismiss: () => selectedLocationStore.value = null,
                          ),
                        if (showBanner)
                          Transform.translate(
                            offset: const Offset(0, -20),
                            child: ConnectionTile(
                              showConnectedOnly: true,
                              textConnect: 'Switch to ${selectedLocation.getName(context)}',
                            ),
                          )
                        else if (selectedLocation != null && vpnStore.location != null)
                          const ConnectionTile(showConnectedOnly: true)
                        else
                          const ConnectionTile(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const LocationsSliverView(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedLocationBanner extends StatelessWidget {
  const _SelectedLocationBanner({
    required this.location,
    required this.onDismiss,
  });

  final VPNLocation location;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.c.isDarkMode ? const Color(0xFF6A678E) : const Color(0xFFC6C5D3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Row(
            children: [
              CircleFlag(location.countryCode, size: 38),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location.getName(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: SvgIcon(
                  asset: Asset.icons.close3(context),
                  color: context.c.isDarkMode ? Palette.white : const Color(0xFF6A678E),
                ),
              ),
            ],
          ),
        ),
      );
}
