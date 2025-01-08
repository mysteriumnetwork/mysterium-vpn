import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_app_bar.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelController = useMemoized(PanelController.new);

    final theme = Theme.of(context);
    final homeState = ref.watch(homeStateProvider.notifier);

    useEffect(
      () {
        homeState.panelController = panelController;
        return () => homeState.panelController = null;
      },
      [panelController, homeState],
    );

    return LayoutBuilder(
      builder: (context, layoutConstraints) {
        final minHeight = max<double>(
          layoutConstraints.maxHeight * homeState.panelMinExtent,
          // panel should be at least this size in order to fit at least one country
          240,
        );
        final constraints = layoutConstraints.copyWith(
          maxHeight: max(layoutConstraints.maxHeight * homeState.panelMaxExtent, minHeight),
          minHeight: minHeight,
        );

        return SlidingUpPanel(
          maxHeight: constraints.maxHeight,
          minHeight: constraints.minHeight,
          controller: homeState.panelController,
          color: theme.primaryColor,
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
          body: Column(
            children: [
              Expanded(
                flex: 10 - (homeState.panelMinExtent * 10).round(),
                child: const HomeConnectionView(header: HomeMobileAppBar()),
              ),
              Spacer(flex: (homeState.panelMinExtent * 10).round()),
            ],
          ),
        );
      },
    );
  }
}
