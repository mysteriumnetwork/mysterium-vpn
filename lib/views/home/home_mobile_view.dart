import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_banner.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_app_bar.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart' hide PanelState;

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final abTestingStore = ref.watch(abTestingStorePOD);

    final bannerDisplayVariant = useComputedValue(() => abTestingStore.bannerDisplayVariant);
    final theme = Theme.of(context);
    final homeState = ref.watch(homeStateProvider.notifier);
    final (appBarKey, appBarBox) = useRenderObject<RenderBox>();
    final appBarHeight = appBarBox?.size.height ?? kToolbarHeight;
    final panelFlex = ref.watch(homePanelFlexProvider);

    return LayoutBuilder(
      builder: (context, layoutConstraints) {
        final minHeight = max<double>(
          layoutConstraints.maxHeight * PanelState.closed.extent,
          // panel should be at least this size in order to fit at least one country
          42,
        );
        final constraints = layoutConstraints.copyWith(
          maxHeight: max(layoutConstraints.maxHeight * PanelState.open.extent, minHeight),
          minHeight: minHeight,
        );

        return Stack(
          children: [
            SlidingUpPanel(
              maxHeight: constraints.maxHeight,
              minHeight: constraints.minHeight,
              controller: homeState.panelController,
              color: theme.primaryColor,
              snapPoint: PanelState.snap.extent,
              isDraggable: homeState.isDraggable,
              panelBuilder: (sc) => HookBuilder(
                builder: (context) {
                  homeState.scrollController = sc;
                  return LocationsSliderMobileView(constraints: constraints, controller: sc);
                },
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              onPanelSlide: homeState.onPanelSlide,
              body: Column(
                children: [
                  Expanded(
                    flex: 10 - panelFlex,
                    child: HomeConnectionView(header: HomeMobileAppBar(key: appBarKey)),
                  ),
                  Spacer(flex: panelFlex),
                ],
              ),
            ),
            switch (bannerDisplayVariant) {
              'B' => Positioned(
                  top: 24 + appBarHeight,
                  left: 0,
                  right: 0,
                  child: const HomeBanner(),
                ),
              'C' => const Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: HomeBanner(),
                ),
              _ => const SizedBox.shrink(),
            },
          ],
        );
      },
    );
  }
}
