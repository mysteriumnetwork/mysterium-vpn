import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_search.dart';
import 'package:mysterium_vpn/features/locations/views/locations_view.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeDesktopLeftPanel extends StatefulWidget {
  const HomeDesktopLeftPanel({super.key});

  @override
  State<HomeDesktopLeftPanel> createState() => _HomeDesktopLeftPanelState();
}

class _HomeDesktopLeftPanelState extends State<HomeDesktopLeftPanel> with WidgetsBindingObserver {
  final _analyticsStore = getIt<AnalyticsStore>();
  final _scrollController = ScrollController();
  Brightness? _brightness;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_analyticsStore.logLocationsListScroll);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateBrightness();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HomeStateScope.read(context).scrollController = _scrollController;
  }

  void _updateBrightness() {
    final b = Scaffold.maybeOf(context)?.widget.backgroundColor.brightness;
    if (b != _brightness && mounted) {
      setState(() => _brightness = b);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateBrightness();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateBrightness();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_analyticsStore.logLocationsListScroll);
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _brightness ?? Theme.of(context).brightness;
    final palette = Theme.of(context).palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgSidePanel,
        boxShadow: [
          switch (brightness) {
            Brightness.dark => BoxShadow(
              color: palette.bgPrimary.withValues(alpha: .2),
              blurRadius: 100,
            ),
            Brightness.light => BoxShadow(
              color: palette.bgPrimary.withValues(alpha: .04),
              blurRadius: 16,
              offset: const Offset(4, -4),
            ),
          },
        ],
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPinnedHeader(
            child: DecoratedBox(
              decoration: BoxDecoration(color: palette.bgSidePanel),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Header.logo(
                    showBackButton: false,
                    backgroundColor: palette.bgSidePanel,
                    actions: [
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(UntitledUI.message_question_square, size: 24),
                        onPressed: () =>
                            handleOnSupportPage(context: context, analyticsStore: _analyticsStore),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(UntitledUI.settings_01, size: 24),
                        onPressed: () {
                          _analyticsStore.logEvent(AnalyticsEvent.openSettings);
                          context.beamToNamed(Routes.settings.path);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Theme.of(context).spacing.xl3,
                      Theme.of(context).spacing.s,
                      Theme.of(context).spacing.xl3,
                      Theme.of(context).spacing.xl3,
                    ),
                    child: const LocationsSearch(),
                  ),
                ],
              ),
            ),
          ),
          const SliverClip(
            child: SliverPadding(padding: EdgeInsets.zero, sliver: LocationsSliverView()),
          ),
        ],
      ),
    );
  }
}

extension _ColorBrightnessExtension on Color? {
  Brightness? get brightness {
    final color = this;
    if (color == null) {
      return null;
    }
    return color == Palette.white ? Brightness.light : Brightness.dark;
  }
}
