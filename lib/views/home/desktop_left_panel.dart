import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_app_bar.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeDesktopLeftPanel extends HookConsumerWidget {
  const HomeDesktopLeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
    final scrollController = useScrollController()
      ..addListener(analyticsStore.logLocationsListScroll);
    final brightness = useScaffoldBrightness();

    ref.read(homeStateProvider).scrollController = scrollController;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Scaffold.maybeOf(context)?.widget.backgroundColor,
        boxShadow: [
          switch (brightness) {
            Brightness.dark => BoxShadow(
              color: const Color(0xFF090064).withValues(alpha: .2),
              blurRadius: 100,
            ),
            Brightness.light => BoxShadow(
              color: Palette.lightBlack.withValues(alpha: .04),
              blurRadius: 16,
              offset: const Offset(4, -4),
            ),
          },
        ],
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPinnedHeader(
            child: HomeAppBar(
              supportIcon: Asset.icons.supportDesktop(context),
              settingsIcon: Asset.icons.settingsDesktop(context),
            ),
          ),
          const SliverClip(
            child: SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              sliver: LocationsSliverView(),
            ),
          ),
        ],
      ),
    );
  }
}
