import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_app_bar.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart' hide PanelState;

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final theme = Theme.of(context);
    final homeState = ref.watch(homeStateProvider.notifier);
    final (appBarKey, appBarBox) = useRenderObject<RenderBox>();
    final appBarHeight = appBarBox?.size.height ?? kToolbarHeight;
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final topSectionHeight = appBarHeight + 40;

    useReaction(
      () => vpnStore.vpnStatus,
      (status) {
        if (status != VpnConnectionStatus.connected) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeState.collapsePanel();
        });
      },
      keys: [homeState],
    );

    useReaction(
      () => locationsQueryStore.search,
      (_) {
        homeState.scrollToLocations();
      },
      keys: [homeState],
      equals: (String? c, String? p) {
        if ((p?.isEmpty ?? true) && (c?.isNotEmpty ?? false)) {
          return false;
        }
        return true;
      },
    );

    return LayoutBuilder(
      builder: (context, layoutConstraints) => Observer(
        builder: (context) {
          final minHeight = vpnStore.isConnected ? 270.0 : 200.0;
          final constraints = layoutConstraints.copyWith(
            maxHeight: max(
              (layoutConstraints.maxHeight * PanelState.open.extent) - topSectionHeight,
              minHeight,
            ),
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
                isDraggable: isMobile(),
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
                onPanelClosed: homeState.onPanelSlide,
                onPanelOpened: homeState.onPanelSlide,
                body: Consumer(
                  builder: (context, ref, _) => Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest),
                        child: HomeAppBar(
                          key: appBarKey,
                          supportIcon: Asset.icons.support(context),
                          settingsIcon: Asset.icons.settingsAdaptive(context),
                        ),
                      ),
                      const Expanded(child: HomeConnectionView()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
