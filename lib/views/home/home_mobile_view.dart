import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart' hide PanelState;
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
    final topSectionHeight = appBarHeight;
    final analyticsStore = ref.read(analyticsStorePOD);

    useReaction(() => vpnStore.connectionStatus, (status) {
      if (status != VpnConnectionStatus.connected) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeState.collapsePanel();
      });
    }, keys: [homeState]);

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
          final bottomOffset = MediaQuery.paddingOf(context).bottom + theme.spacing.md;
          final minHeight = (vpnStore.isConnected ? 300.0 : 200.0) + bottomOffset;
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
                color: theme.palette.bgSidePanel,
                snapPoint: PanelState.snap.extent,
                isDraggable: isMobile(),
                panelBuilder: (sc) => HookBuilder(
                  builder: (context) {
                    homeState.scrollController = sc;
                    return LocationsSliderMobileView(constraints: constraints, controller: sc);
                  },
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.kM, topRight: Radius.kM),
                onPanelSlide: homeState.onPanelSlide,
                onPanelClosed: homeState.onPanelSlide,
                onPanelOpened: homeState.onPanelSlide,
                body: Consumer(
                  builder: (context, ref, _) => Column(
                    children: [
                      DecoratedBox(
                        key: appBarKey,
                        decoration: BoxDecoration(color: theme.palette.bgPrimary),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Header.logo(
                              showBackButton: false,
                              actions: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(32, 32),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: const Icon(UntitledUI.message_question_square, size: 24),
                                  onPressed: () => handleOnSupportPage(
                                    context: context,
                                    analyticsStore: ref.read(analyticsStorePOD),
                                  ),
                                ),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(32, 32),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: const Icon(UntitledUI.settings_01, size: 24),
                                  onPressed: () {
                                    analyticsStore.logEvent(AnalyticsEvent.openSettings);
                                    context.beamToNamed(Routes.settings.path);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                theme.spacing.md,
                                0,
                                theme.spacing.md,
                                theme.spacing.ms,
                              ),
                              child: const LocationsSearch(),
                            ),
                          ],
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
