import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/views/home_connection_view.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_search.dart';
import 'package:mysterium_vpn/features/locations/views/locations_slider_mobile_view.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart' hide PanelState;
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeMobileView extends StatefulWidget {
  const HomeMobileView({super.key});

  @override
  State<HomeMobileView> createState() => _HomeMobileViewState();
}

class _HomeMobileViewState extends State<HomeMobileView> {
  final _vpnStore = getIt<VpnStore>();
  final _locationsQueryStore = getIt<LocationsQueryStore>();
  final _analyticsStore = getIt<AnalyticsStore>();

  final _appBarKey = GlobalKey();
  RenderBox? _appBarBox;

  final List<ReactionDisposer> _disposers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _appBarKey.currentContext;
      final obj = ctx?.findRenderObject();
      if (obj is RenderBox && mounted) setState(() => _appBarBox = obj);
    });
  }

  void _setupReactions() {
    if (_disposers.isNotEmpty) return;
    final homeState = HomeStateScope.read(context);

    _disposers.addAll([
      reaction((_) => _vpnStore.connectionStatus, (status) {
        if (status != VpnConnectionStatus.connected) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeState.collapsePanel();
        });
      }),
      reaction(
        (_) => _locationsQueryStore.search,
        (_) {
          homeState.scrollToLocations();
        },
        equals: (String? c, String? p) {
          if ((p?.isEmpty ?? true) && (c?.isNotEmpty ?? false)) return false;
          return true;
        },
      ),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupReactions();
  }

  @override
  void dispose() {
    for (final d in _disposers) {
      d();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeState = HomeStateScope.of(context);
    final appBarHeight = _appBarBox?.size.height ?? kToolbarHeight;
    final topSectionHeight = appBarHeight;

    return LayoutBuilder(
      builder: (context, layoutConstraints) => Observer(
        builder: (context) {
          final bottomOffset = MediaQuery.paddingOf(context).bottom + 16;
          final minHeight = (_vpnStore.isConnected ? 300.0 : 200.0) + bottomOffset;
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
                panelBuilder: (sc) => Builder(
                  builder: (context) {
                    homeState.scrollController = sc;
                    return LocationsSliderMobileView(constraints: constraints, controller: sc);
                  },
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.kM, topRight: Radius.kM),
                onPanelSlide: homeState.onPanelSlide,
                onPanelClosed: homeState.onPanelSlide,
                onPanelOpened: homeState.onPanelSlide,
                body: Column(
                  children: [
                    DecoratedBox(
                      key: _appBarKey,
                      decoration: BoxDecoration(color: theme.palette.bgPrimary),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Header.logo(
                            showBackButton: false,
                            automaticallyImplyLeading: false,
                            actions: [
                              IconButton(
                                icon: const Icon(UntitledUI.message_question_square),
                                onPressed: () => handleOnSupportPage(
                                  context: context,
                                  analyticsStore: _analyticsStore,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(UntitledUI.settings_01),
                                onPressed: () {
                                  _analyticsStore.logEvent(AnalyticsEvent.openSettings);
                                  context.beamToNamed(Routes.settings.path);
                                },
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: LocationsSearch(),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: HomeConnectionView()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
