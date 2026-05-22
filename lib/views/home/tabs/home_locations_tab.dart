import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';
import 'package:mysterium_vpn/views/locations/locations_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeLocationsTab extends HookConsumerWidget {
  const HomeLocationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locationsStore = ref.watch(locationsStorePOD);
    final tabsStore = ref.watch(homeTabsStorePOD);
    final scrollController = useScrollController();
    final focusNode = useFocusNode();

    useEffect(() {
      final homeState = ref.read(homeStateProvider)..scrollController = scrollController;
      return () {
        if (homeState.scrollController == scrollController) {
          homeState.scrollController = null;
        }
      };
    }, [scrollController]);

    useEffect(
      () => reaction<bool>((_) => tabsStore.pendingLocationsSearchFocus, (pending) {
        if (!pending) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (focusNode.canRequestFocus) {
            focusNode.requestFocus();
          }
          tabsStore.consumePendingLocationsSearchFocus();
        });
      }, fireImmediately: true).call,
      const [],
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.palette.bgSidePanel),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPinnedHeader(
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.palette.bgSidePanel),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  theme.spacing.md,
                  0,
                  theme.spacing.md,
                  theme.spacing.ms,
                ),
                child: Observer(
                  builder: (context) =>
                      LocationsSearch(enabled: !locationsStore.hasNoServers, focusNode: focusNode),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            sliver: const LocationsSliverView(),
          ),
        ],
      ),
    );
  }
}
