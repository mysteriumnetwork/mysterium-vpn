import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/scaffold_brightness_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
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
    final pallete = Theme.of(context).palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pallete.bgSidePanel,
        boxShadow: [
          switch (brightness) {
            Brightness.dark => BoxShadow(
              color: pallete.bgPrimary.withValues(alpha: .2),
              blurRadius: 100,
            ),
            Brightness.light => BoxShadow(
              color: pallete.bgPrimary.withValues(alpha: .04),
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
            child: DecoratedBox(
              decoration: BoxDecoration(color: pallete.bgSidePanel),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Header.logo(
                    automaticallyImplyLeading: false,
                    showBackButton: false,
                    backgroundColor: pallete.bgSidePanel,
                    actions: [
                      IconButton(
                        icon: const Icon(UntitledUI.message_question_square),
                        onPressed: () => handleOnSupportPage(
                          context: context,
                          analyticsStore: ref.read(analyticsStorePOD),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(UntitledUI.settings_01),
                        onPressed: () {
                          analyticsStore.logEvent(AnalyticsEvent.openSettings);
                          context.beamToNamed(Routes.settings.path);
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 16),
                    child: LocationsSearch(),
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
