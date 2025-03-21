import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/home_app_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
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

    ref.read(homeStateProvider).scrollController = scrollController;

    return CustomScrollView(
      controller: scrollController,
      slivers: const [
        SliverPinnedHeader(child: HomeAppBar()),
        SliverClip(
          child: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            sliver: LocationsSliverView(),
          ),
        ),
      ],
    );
  }
}
