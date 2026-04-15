import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/views/locations_view.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/connection_tile.dart';
import 'package:mysterium_vpn/shared/components/dragable_indicator.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliderMobileView extends StatefulWidget {
  const LocationsSliderMobileView({required this.constraints, required this.controller, super.key});

  final BoxConstraints constraints;
  final ScrollController controller;

  @override
  State<LocationsSliderMobileView> createState() => _LocationsSliderMobileViewState();
}

class _LocationsSliderMobileViewState extends State<LocationsSliderMobileView> {
  final _analyticsStore = getIt<AnalyticsStore>();
  PanelState? _lastPanelState;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_analyticsStore.logLocationsListScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_analyticsStore.logLocationsListScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: HomeStateScope.of(context),
      builder: (context, _) {
        final panelState = HomeStateScope.of(context).panelState;

        // When the panel is not fully open, reset the scroll to the top so the
        // list always starts fresh when the panel is reopened.
        if (panelState != _lastPanelState) {
          _lastPanelState = panelState;
          if (panelState != PanelState.open &&
              widget.controller.hasClients &&
              widget.controller.offset != 0) {
            widget.controller.jumpTo(0);
          }
        }

        void handleTogglePanel() {
          HomeStateScope.read(context).togglePanel();
        }

        return CustomScrollView(
          physics: switch (panelState) {
            PanelState.open => const AlwaysScrollableScrollPhysics(),
            _ => const NeverScrollableScrollPhysics(),
          },
          dragStartBehavior: DragStartBehavior.down,
          controller: widget.controller,
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
      },
    );
}
